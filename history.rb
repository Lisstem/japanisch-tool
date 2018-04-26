require 'yaml'

class History
  def factors
    [10, 7, 4, 3, 3, 2, 2, 1, 1, 1]
  end

  def initialize
    @guess = {}
  end

  def priority(word)
    word = guess(word)
    prio = 0
    dividend = 0.0
    word.zip(factors).each do |right, factor|
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

  def yaml_copy
    new_guess = {}
    @guess.each_pair do |word, array|
      new_guess[word.my_hash] = array
    end
    old_guess = @guess
    @guess = new_guess
    copy = self.clone
    @guess = old_guess
    copy
  end

  def yaml_finish(words)
    new = {}
    @guess.each_key do |key|
      if words[key].nil?
        puts "Warning userdata for word\n#{key}\n exists but is not loaded."
      else
        new[words[key]] = @guess[key]
      end
    end
    @guess = new
  end
end