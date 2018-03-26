class Test
  def initialize(words, modes)
    @words = words
    @modes = modes
  end

  def run
    product = []
    @words.product(@modes).each do |word, mode|
      1.upto(mode.history.priority(word)*10) do
        product << [word, mode]
      end
    end
    product.shuffle!
    product.each
  end
end
