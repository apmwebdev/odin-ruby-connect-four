# frozen_string_literal: true

class Game
  attr_accessor :players, :board, :moves, :winner, :player1, :player2

  RED_WIN_STR = "redredredred"
  BLACK_WIN_STR = "blackblackblackblack"
  UP_DIAG_ROUTE_STARTS = [[0, 2], [0, 1], [0, 0], [1, 0], [2, 0], [3, 0]]
  DOWN_DIAG_ROUTE_STARTS = [[0, 3], [0, 4], [0, 5], [1, 5], [2, 5], [3, 5]]

  def initialize
    @players = []
    @game_ui = GameUI.new
    @moves = Array.new(7) { [] }
    @player1 = nil
    @player2 = nil
    @winner = nil
  end

  def register_player
    puts "Enter player name"
    @players.push(Player.new(gets.chomp))
  end

  def determine_starting_player
    @player1 = @players.sample
    @player1.goes_first = true
    @player2 = @players.find { |player| player.goes_first == false }
    @player1.color = "red"
    @player2.color = "black"
    # puts "#{@player1.name} goes first."
  end

  def get_win_routes
    routes = []
    # columns
    @moves.each { |col| routes.push(col.join("")) }
    # rows
    rows = Array.new(6) { [] }
    6.times do |i|
      @moves.each { |col| rows[i].push(col[i]) }
    end
    rows.each { |row| routes.push(row.join("")) }
    # diag_up
    up_diags = get_diagonal_up_routes
    up_diags.each { |route| routes.push(route.join("")) }
    # diag_down
    down_diags = get_diagonal_down_routes
    down_diags.each { |route| routes.push(route.join("")) }
    routes
  end

  def get_diagonal_down_routes
    return_arr = []
    DOWN_DIAG_ROUTE_STARTS.each do |coords|
      sub_arr = []
      col = coords[0]
      height = coords[1]
      loop do
        sub_arr.push(@moves[col][height])
        col += 1
        height -= 1
        break if col > 6 || height < 0
      end
      return_arr.push(sub_arr) if sub_arr.length >= 4
    end
    return_arr
  end

  def get_diagonal_up_routes
    return_arr = []
    UP_DIAG_ROUTE_STARTS.each do |coords|
      sub_arr = []
      col = coords[0]
      height = coords[1]
      loop do
        sub_arr.push(@moves[col][height])
        col += 1
        height += 1
        break if col > 6 || height > 5
      end
      return_arr.push(sub_arr) if sub_arr.length >= 4
    end
    return_arr
  end

  def check_for_win
    win_routes = get_win_routes
    win_routes.each do |route|
      if route.include?(RED_WIN_STR)
        @winner = @player1
        break
      elsif route.include?(BLACK_WIN_STR)
        @winner = @player2
        break
      end
    end
  end

  def get_player_move
    loop do
      user_input = gets.chomp
      verified_number = user_input.to_i if user_input.match?(/^[0-7]$/)
      return verified_number if verified_number

      puts "Input error! Please enter a non-full column number (0-6)"
    end
  end
end
