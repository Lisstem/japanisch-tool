require 'yaml'

require_relative 'mode'
require_relative 'lection'
require_relative 'test'
require_relative 'user'
require_relative 'mode'
require_relative 'myio'


class Tool
  def initialize(lection_path, user)
    @status = :initialize
    @commands = %w(q exit quit help test lections)
    @io = MyIO.new(@commands, true)

    @lection_path = lection_path
    @lections = Lection.load_dir(lection_path)
    all = Lection.new('all', [], nil, 'Contains all loaded words.')
    @lections.each_value do |lection|
      all.join(lection)
    end
    @lections['all'] = all

    @user = User.from_file(user, (@lections['all'].words.map{|x| [x.my_hash, x]}).to_h)
    create_modes(@user)
  end

  def main
    @status = :main
    while @status == :main
      input = @io.readline("#{@user.name}@jptool> ", nil,true)
      if input.nil?
        break
      end
      input = input.split(' ')
      if input.empty?
        next
      end

      input[0] = input[0].strip.downcase
      if @commands.include? input[0]
        @status = input[0].to_sym
        if @status == :q || @status == :quit
          @status = :exit
        end
      else
        input.unshift(nil)
        @status = :none
      end
      send @status, *(input[1..-1])
    end
    @user.save
  end

  def lections(*args)
    if args.empty?
      out = 'Loaded Lections:'
      @lections.each_value do |lection|
        out << "\n\t- #{lection}"
      end
      @io.puts out
    else
      lection = args[0].strip
      if @lections[lection].nil?
        choice("Lection '#{lection}' does not exist.\nCreate this Lection?", Proc.new {@status = :lections_create
            lections_create(lection)})
      else
        lection = @lections[lection]
        @io.puts("#{lection.name}:")
        @io.puts("\tFilename: #{lection.file}")
        @io.puts("\tInfo: #{lection.info}")
        @io.puts("\tWords (#{lection.words.count}):")
        lection.words.each do |word|
          @io.puts("\t\t- #{word}")
        end
        unless lection == @lections['all']
          choice('Add words?', Proc.new{@status = :lections_words
              lections_words(lection, :lections);lection.save})
        end
      end
    end
    @status = :main
  end

  def lections_create(*args)
    name = ''
    @io.puts("Create lection:")
    while name == ''
      default = args[0].nil? ? '' : args[0].strip
      name = @io.readline("\tName: ", default).strip
      if name == '' && default == ''
        @io.puts("A name must be given.")
        next
      end
      name = default if name == ''
      if @lections.include? name
        @io.puts("Lection '#{name}' already exists. Please choose another name.")
        name = ''
        next
      end
    end
    file = ''
    while file == ''
      default = args[1].nil? ? "lections/#{name}.yaml" : args[1].strip
      file = @io.readline("\tFilename: ", default).strip
      file = default if file == ''
    end
    info = @io.readline("\tInformation: ", args[2].nil? ? nil : args[2].strip).strip
    info = args[2] if (info == '' && !args[2].nil?)
    info.gsub!('\n', "\n")
    @lections[name] = lection = Lection.new(name, [], file, info)
    choice('Add words?', Proc.new{@status = :lections_words
        lections_words(lection, :lections_create)})
    lection.save
    @status = :lections
  end

  def lections_words(lection, last, *args)
    if lection == @lections['all']
      @io.puts("You cannot add words to lection 'all'.")
      @status = last
      return
    end
    @io.puts("Added words to lection '#{lection.name}'.\nSeparete translations with ', '.\nPress 'q' to exit.")
    while @status == :lections_words
      kana = ''
      while kana == ''
        kana = @io.readline('Kana: ').strip
        if kana.downcase == 'q'
          return
        end
        if kana == ''
          @io.puts('Kana cannot be empty.')
        end
      end
      translations = nil
      while translations.nil?
        translations = @io.readline('Translations: ').strip
        if translations.downcase == 'q'
          return
        end
        translations = translations.split(', ').map{|translation| translation.strip}.select{|translation| translation != ''}
        if translations.empty?
          @io.puts('There must be at least one translation.')
          translations = nil
        end
      end
      kanji = @io.readline('Kanji: ').strip
      if kanji.downcase == 'q'
        return
      end
      info = @io.readline('Information: ').strip
      if info.downcase == 'q'
        return
      end
      word = Word.new(kana, translations, kanji, lection.name, info)
      choice("Word: #{word}\nAdd this word?", Proc.new{lection.add_word(word);@lections['all'].add_word(word)})
      choice('Add another word?', Proc.new{}, Proc.new{@status = last})
    end
  end

  def help(*args)
    @io.puts Tool.help_texts[args[0]]
    @status = :main
  end

  def none(*args)
    unless args.empty?
      @io.puts "Unknown command '#{args[0]}'.\nUse 'help' for help."
    end
    @status = :main
  end

  def exit(*args)
    @io.puts 'ending program'
  end

  def test(*args)
    if args.empty?
      args = ['all']
    end
    @io.puts 'starting test'
    words = Lection.new('test')
    args.each do |arg|
      other = @lections[arg]
      if other.nil?
        @io.puts "Could not find lection '#{arg}'."
      else
        words.join(other)
      end
    end
    @io.puts "Enter 'q' to end the test."

    test = Test.new(words.words, [@modes[:kana2trans], @modes[:trans2kana]])
    test.run.each do |word, mode|
      unless @status == :test
        break
      end
      @io.puts mode.question(word)
      input = @io.readline('answer: ').strip
      case input
        when 'q'
          @status = :main
        else
          mode.answer(word, input)
      end
    end
    @status = :main
  end

  def load_user(file, words)
    User.from_file(file, words)
  end

  def wrap_kanji(block)
    Proc.new do |word, guess|
      unless word.kanji.nil?
        return block.call(word, guess)
      end
      return true
    end
  end

  def create_proc(check, correct_answer)
    Proc.new do |word, guess|
      if word.send(check, guess)
        @io.puts "Correct."
        true
      else
        @io.puts "Wrong.\n" + correct_answer.call(word)
        false
      end
    end
  end

  def create_modes(user)
    @modes = {}
    @modes[:kanji2kana] =     Mode.new(user.history(:kanji2kana), Proc.new{|word| "Write #{word.kanji} with kana."},
                                       wrap_kanji(create_proc(:match_kana,
                                                              Proc.new{|word| "The correct answer is #{word.kana}."})))
    @modes[:kanji2trans] =    Mode.new(user.history(:kanji2trans), Proc.new{|word| "Translate #{word.kanji}."},
                                       wrap_kanji(create_proc(:match_translation,
                                                              Proc.new{|word| "Correct answers are #{word.translations.join(', ')}."})))
    @modes[:kanji2transall] = Mode.new(user.history(:kanji2transall), Proc.new{|word| "Give all translations of #{word.kanji}."},
                                       wrap_kanji(create_proc(:match_all_translations,
                                                              Proc.new{|word| "The correct answer is #{word.translations.join(', ')}."})))
    @modes[:kana2trans] =     Mode.new(user.history(:kana2trans), Proc.new{|word| "Translate #{word.kana}.\n"},
                                       create_proc(:match_translation,
                                                   Proc.new{|word| "Correct answers are #{word.translations.join(', ')}."}))
    @modes[:kana2transall] =  Mode.new(user.history(:kana2transall), Proc.new{|word| "Give all translations of #{word.kana}.\n"},
                                       create_proc(:match_all_translations,
                                                   Proc.new{|word| "The correct answer is #{word.translations.join(', ')}."}))
    @modes[:trans2kanji] =    Mode.new(user.history(:trans2kanji), Proc.new{|word| "Translate #{word.translations.join(', ')} (kanji)."},
                                       wrap_kanji(create_proc(:match_kanji,
                                                              Proc.new{|word| "The correct answer is #{word.kanji}."})))
    @modes[:trans2kana] =     Mode.new(user.history(:trans2kana), Proc.new{|word| "Translate #{word.translations.join(', ')} (kana)."},
                                       create_proc(:match_kana,
                                                   Proc.new{|word| "The correct answer is #{word.kana}."}))
  end

  def choice(question, yes = Proc.new {}, no = Proc.new {})
    flag = true
    while flag
      input = @io.readline("#{question} (yes/no) ").strip.downcase
      case input
        when 'y'
          flag = false
          yes.call
        when 'yes'
          flag = false
          yes.call
        when 'no'
          flag = false
          no.call
        when 'n'
          flag = false
          no.call
        else
          # do nothing
      end
    end
  end

  @help_texts = {nil => "Commands:
\thelp:          Get help to commands.
\tlections:      Prints information about the loaded lections.
\tquit, q, exit: Ends the program.
\ttest:          Starts a test.

Try 'test command' to get more info about a command", 'help' => "help [command]
\tPrints list of commands if no command is given,
\totherwise gives more information about the given command.", 'test' => "test [lection1] [lection2] [...]
\tStarts a test with the lections lection1, lection2, ...
\tIf no lection is given all lections will be included.", 'exit' => "quit, q, exit\n\tEnds the program.",
  'q' => "quit, q, exit\n\tEnds the program.", 'quit' => "quit, q, exit\n\tEnds the program.",
  'lections' => "lections [lection]
\tPrints the names of all lections if no lection is given,
\totherwise prints the full information about the given lection.
\tIf the lection does not exist, you can create it.
\tYou can also add words to the lection."}
  def self.help_texts
    return @help_texts
  end
end

def generate_error_report(tool, exception)
  report = ({'state' => tool, 'error' => exception,
           'backtrace' => "#{exception.backtrace.join("\n")}: #{exception.message} (#{exception.class})"}.to_yaml)
  i = 0
  name = Time.new.strftime('%FT%R')
  while File.exist? "#{name}_#{i}.yaml"
    i += 1
  end
  file = File.open "#{name}_#{i}.yaml" , 'w'
  file.puts report
  puts "Report saved in #{name}_#{i}.yaml."
end



tool = Tool.new('lections', 'lisstem.yaml')
begin
  tool.main
rescue => ex
  flag = true
  puts "An error occurred. An error report can be generated.
      It will contain all of your inputs in this session as well as the current state of the program.
      This includes all of the words and your user data."
  while flag
    print "Generate error report? (yes/no) "
    input = gets.strip.downcase
    case input
      when 'y'
        flag = false
        generate_error_report(tool, ex)
      when 'yes'
        flag = false
        generate_error_report(tool, ex)
      when 'no'
        flag = false
      when 'n'
        flag = false
      when 'show'
        puts "#{ex.backtrace.join("\n")}: #{ex.message} (#{ex.class})"
      else
        # do nothing
    end
  end
end