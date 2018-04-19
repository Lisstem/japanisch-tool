require 'readline'

class MyIO
  def initialize(commands, debug = false)
    @debug = debug
    @log = []
    commands.sort

    comp = proc { |s| commands.grep(/^#{Regexp.escape(s)}/) }

    Readline.completion_append_character = " "
    Readline.completion_proc = comp
  end

  def puts(value)
    if @debug
     @log << [:out, value.to_s + "\n"]
    end
    Kernel.puts(value)
  end

  def gets
    input = Kernel.gets
    if input.nil?
      exit
    end
    if @debug
      @log << [:in, input]
    end
    input
  end

  def readline(prompt = '', history = false)
    if @debug && !prompt.nil? && !(prompt == '')
      @log << [:out, prompt]
    end
    input = Readline.readline(prompt, history)
    if input.nil?
      exit
    end
    if @debug
      @log << [:in, input]
    end
    input
  end

  def print(value)
    if @debug
      @log << [:out, value.to_s]
    end
    Kernel.print(value)
  end
end