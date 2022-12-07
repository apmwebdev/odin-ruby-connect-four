# frozen_string_literal: true

class Player
  attr_accessor :name, :goes_first, :turns_taken, :is_winner, :color, :piece

  def initialize(name)
    @name = name
    @goes_first = false
    @turns_taken = 0
    @is_winner = false
    @color = ""
    @piece = nil
  end
end
