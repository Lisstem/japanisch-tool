class MyIO
  def initialize(debug = false)
    @debug = debug
    @log = []
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

  def print(value)
    if @debug
      @log << [:out, value.to_s]
    end
    Kernel.print(value)
  end
end