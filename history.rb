require 'yaml'

class History
  @factors = [10, 7, 4, 3, 3, 2, 2, 1, 1, 1]

  def initialize
    @guess = {}
  end

  def priority(word)
    return 1
    word = guess(word)
    prio = 0
    dividend = 0.0
    word.zip(@factors).each do |right, factor|
      prio += right*factor
      dividend += factor
    end
    prio / dividend
  end

  def latest(word, right)
    new = guess(word)
    new.rotate!(-1)
    new[0] = right ? 0 : 1
    @guess[word] = new
  end

  def guess(word)
    if @guess[word].nil?
      @guess[word] = Array.new(10).fill(1)
    end
    @guess[word].clone
  end

  def my_to_yaml
    new_guess = {}
    @guess.each_pair do |word, array|
      new_guess[word.my_hash] = array
    end
    old_guess = @guess
    @guess = new_guess
    yaml = self.to_yaml
    @guess = old_guess
    yaml
  end

  def yaml_finish(words)
    @guess.each_key do |key|
      @guess[words[key]] = @guess.delete[key]
    end
  end
end