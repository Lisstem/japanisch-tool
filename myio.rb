class MyIO
  def initialize(debug = false)
    @debug = debug
    @out = []
    @in = []
  end

  def puts(value)
    if @debug
     @out << value
    end
    Kernel.puts(value)
  end

  def gets
    input = Kernel.gets
    if @debug
      @in << input
    end
    input
  end

  def print(value)
    if @debug
      @out << value
    end
    Kernel.print(value)
  end
end