class Mode
  attr_reader :history

  def initialize(history, question, answer)
    @history = history
    @answer = answer
    @question = question
  end

  def question(word)
    @question.call(word)
  end

  def answer(word, guess)
    result = @answer.call(word, guess)
    @history.latest(word, result)
    result
  end
end