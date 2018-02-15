require 'yaml'

class Lection
  attr_reader :name, :words
  attr_accessor :file

  def initialize(name, words = [])
    @name = name
    @words = words
    @file = nil
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
    if File.file?(file)
      file = File.open(file, 'w')
    else
      file = File.new(file, 'w')
    end
    file.write(self.to_yaml)
    file.close
  end

  def join(*lection)
    lection.each do |other|
      @words.concat(other.words)
    end
  end
end