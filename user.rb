require 'yaml'
require_relative 'history'

class User
  attr_reader :name, :file
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
    user = YAML::load File.open(file, 'r')
    user.instance_variable_get(:@histories).each_index do |history|
      history.yaml_finish(words)
    end
  end
end