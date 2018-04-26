require 'yaml'
require_relative 'history'

class User
  attr_reader :name
  attr_accessor :file
  def initialize(name, file)
    @name = name
    @file = file
    @histories = {}
  end

  def history(mode)
    history = @histories[mode]
    if history.nil?
      history = History.new
      @histories[mode] = history
    end
    history
  end

  def self.from_file(file, words)
    if File.file?(file)
      user = YAML::load(File.open(file, 'r'))
      user.file = file
      user.instance_variable_get(:@histories).each_value do |history|
        history.yaml_finish(words)
      end
      user
    else
      index = file =~ /.yaml/
      if index > 1
        name = file[0...index]
      else
        name = file
      end
      User.new(name, file)
    end
  end

  def to_yaml
    old_histories = @histories
    new_histories = {}
    @histories.each_pair do |mode, history|
      new_histories[mode] = history.yaml_copy
    end
    @histories = new_histories
    yaml = YAML.dump(self)
    @histories = old_histories
    yaml
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
end