require 'yaml'
require_relative 'word.rb'

class Lection
  attr_reader :name, :words
  attr_accessor :file

  def initialize(name, words = [], file = nil)
    @name = name
    @words = words
    @file = file
  end

  def add_word(word)
    @words << word
  end

  def from_file(filepath)
    if File.file?(filepath)
      lection = YAML::load(File.open(filepath, 'r'))
      lection.file = filepath
    else
      nil
    end
  end

  def save(file = @file)
    unless file.nil?
      if File.file?(file)
        file = File.open(file, 'w')
      else
        file = File.new(file, 'w')
      end
      file.write(self.to_yaml)
      file.close
    end
  end

  def join(*lection)
    lection.each do |other|
      @words.concat(other.words)
    end
  end

  def self.parse_csv(file, split)
    lections = {}
    if File.file?(file)
      csv = File.open(file, 'r')
      header = csv.readline.strip!.split(',')
      map = {:kana => nil, :kanji => nil, :translations => nil, :info => nil, :lection => nil}
      header.each_index do |i|
        case header[i].downcase
          when 'kana' then map[:kana] = i
          when 'kanji' then map[:kanji] = i
          when 'translations' then map[:translations] = i
          when 'info' then map[:info] = i
          when 'lection' then map[:lection] = i
          else
            # do nothing
        end
      end
      raise IOError, 'Missing kana or translations in header.' if map[:kana].nil? or map[:translations].nil?

      kanji = nil
      info = nil
      lection = nil
      csv.each_line do |line|
        line = line.strip.split(',')
        kana = line[map[:kana]]
        translations = line[map[:translations]]
        if kana.nil? || kana == '' || translations.nil? || translations == ''
          next
        end
        kana.strip!
        kanji = line[map[:kanji]] unless map[:kanji].nil?
        kanji.strip! unless kanji.nil?
        info = line[map[:info]] unless map[:info].nil?
        info.strip! unless info.nil?
        lection = line[map[:lection]] unless map[:lection].nil?
        lection.strip! unless lection.nil?

        if kanji == ''
          kanji = nil
        end

        translations = translations.split(split)
        translations.each do |translation|
          translation.strip!
          translation.gsub!('/', ',')
        end

        if lection == '' || lection.nil?
          lection = 'default'
        end

        if lections[lection].nil?
          lections[lection] = Lection.new(lection, [], lection + '.yaml')
        end

        lections[lection].add_word(Word.new(kana.strip!, translations, kanji, lections[lection], info))
      end
    else
      raise IOError, "File \"#{file}\" does not exist."
    end
    return lections
  end
end