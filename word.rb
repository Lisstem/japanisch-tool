class Word
  attr_reader :kana, :kanji, :bedeutungen, :lection, :info
  def initialize(kana, bedeutungen, kanji = nil, lection = nil, info = '')
    @kana = kana
    @bedeutungen = bedeutungen
    @kanji = kanji
    @lection = lection
    @info = info
  end

  def to_s
    "#{kana}#{" #{kanji}" unless kanji.nil?} #{bedeutungen.join(',')}"
  end

  def match_bedeutung(guess)
    @bedeutungen.each do |bedeutung|
      if bedeutung.downcase == guess.downcase
        return true
      end
    end
    false
  end

  def match_all_bedeutungen(bedeutungen)
    count = 0
    bedeutungen.each do |guess|
      @bedeutungen.each do |bedeutung|
        if guess.downcase == bedeutung.downcase
          count = count + 1
          break
        end
      end
    end
    count == @bedeutungen.count
  end

  def match_kana(guess)
    @kana.downcase == guess.downcase
  end

  def match_kanji(guess)
    @kanji.downcase == guess.downcase
  end
end