require 'yaml'

require_relative 'mode'
require_relative 'lection'
require_relative 'test'
require_relative 'user'
require_relative 'mode'
require_relative 'myio'


class Tool
  def initialize(lection_path, user)
    @lection_path = lection_path
    @user = User.new(user, user)
    @io = MyIO.new(true)
    create_modes(@user)
    @lections = Lection.load_dir(lection_path)
    @status = :initialize
  end

  def main
    @status = :main
    while @status == :main
      @io.print "#{@user.name}@jptool> "
      input = @io.gets.strip
      @io.puts input
      case input.downcase
        when 'q'
          @status = :exit
        when 'exit'
          @status = :exit
        when 'quit'
          @status = :exit
        when 'help'
          @status = :help
        when 'test'
          @status = :test
        else
          @status = :none
      end
      send @status
    end
  end

  def help
    @io.puts 'help text'
    @status = :main
  end

  def none
    @status = :main
  end

  def exit
    @io.puts 'ending program'
  end

  def test
    @io.puts 'starting test'
    test = Test.new(@lections['1'].words, [@modes[:kana2trans], @modes[:trans2kana]])
    test.run.each do |word, mode|
      unless @status == :test
        break
      end
      @io.puts mode.question(word)
      input = @io.gets.strip
      case input
        when 'q'
          @status = :main
        else
          mode.answer(word, input)
      end
    end
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



tool = Tool.new('lections', 'lisstem')
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