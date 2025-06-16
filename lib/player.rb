
class Player
  attr_accessor :score
  def initialize
    @score = 0
  end

  def increment_score(amount)
    @score+=amount
  end

  def reset_score
    @score = 0
  end
end