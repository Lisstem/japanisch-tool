require_relative 'hepburn'
class Word
  attr_reader :kana, :kanji, :translations, :lection, :info
  def initialize(kana, translations, kanji = nil, lection = 'default', info = '')
    @kana = kana
    @translations = translations
    @kanji = kanji
    @lection = lection
    @info = info
  end

  def to_s
    "#{kana}#{" #{kanji}" unless kanji.nil?} #{translations.join(',')}"
  end

  def match_translation(guess)
    @translations.each do |translation|
      if translation.downcase == guess.strip.downcase
        return true
      end
    end
    false
  end

  def match_all_translations(guesses)
    guesses = guesses.strip!.split(',')
    count = 0
    guesses.each do |guess|
      @translations.each do |translation|
        if guess.downcase == translation.strip.downcase
          count = count + 1
          break
        end
      end
    end
    count == @translations.count
  end

  def match_kana(guess)
    guess = guess.strip
    puts "#{guess}, #{guess.to_katakana}, #{guess.to_hiragana}"
    @kana.downcase == guess.to_katakana || @kana.downcase == guess.to_hiragana
  end

  def match_kanji(guess)
    @kanji.downcase == guess.strip.downcase
  end

  def my_hash
    self.to_s.hash
  end
end