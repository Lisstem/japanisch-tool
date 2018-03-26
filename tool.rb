require_relative 'mode'
require_relative 'lection'
require_relative 'test'
require_relative 'user'
require_relative 'mode'

class Tool
  def initialize(lection_path, user)
    @lection_path = lection_path
    @user = User.new(user, user)
    create_modes(@user)
    @lections = Lection.load_dir(lection_path)
    @status = :main
    send @status
  end

  def main
    while @status == :main
      print "#{@user.name}@jptool> "
      input = gets.strip.downcase
      puts input
      case input
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
    puts 'help text'
    @status = :main
  end

  def none
    @status = :main
  end

  def exit
    puts 'ending program'
  end

  def test
    puts 'starting test'
    test = Test.new(@lections['1'].words, [@modes[:kana2trans], @modes[:trans2kana]])
    test.run.each do |word, mode|
      unless @status == :test
        break
      end
      puts mode.question(word)
      input = gets.strip
      case input
        when 'q'
          @status = :main
        else
          mode.answer(word, input)
      end
    end
  end

  def load_lections

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
        puts "Correct."
        true
      else
        puts "Wrong.\n" + correct_answer.call(word)
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

tool = Tool.new('lections', 'lisstem')