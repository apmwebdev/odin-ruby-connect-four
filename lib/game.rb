# frozen_string_literal: true

class Game
  attr_accessor :players, :board, :moves, :winner, :player1, :player2

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

  def start_game
    2.times { register_player }
    determine_starting_player
    play_game
  end

  def register_player
    puts "Enter player name"
    name = gets.chomp
    @players.push(Player.new(name))
  end

  def determine_starting_player
    @player1 = @players.sample
    @player1.goes_first = true
    @player2 = @players.find { |player| player.goes_first == false }
    @player1.color = GameUI::P1_COLOR
    @player1.piece = @game_ui.p1_piece
    @player2.color = GameUI::P2_COLOR
    @player2.piece = @game_ui.p2_piece
  end

  def play_game
    until @winner
      @game_ui.clear_screen
      @game_ui.render_game(@moves)
      if @player1.turns_taken == @player2.turns_taken
        puts show_turn_instructions(@player1)
        take_turn(@player1)
      else
        puts show_turn_instructions(@player2)
        take_turn(@player2)
      end
      check_for_win
    end
    @game_ui.clear_screen
    @game_ui.render_game(@moves)
    puts "#{@winner.name} wins!"
  end

  def show_turn_instructions(player)
    return_str = "'s turn: Choose a column (numbered 1 to 7)"
    "\n#{player.piece} #{player.name}#{return_str}"
  end

  def take_turn(player)
    move = get_player_move
    @moves[move].push(player.color)
    player.turns_taken += 1
  end

  def get_player_move
    loop do
      user_input = gets.chomp
      if user_input.match?(/^[1-7]$/)
        verified_number = verify_input(user_input.to_i - 1)
        return verified_number if verified_number
      end

      puts "Input error! Please enter a non-full column number (1-7)"
    end
  end

  def verify_input(input)
    input if @moves[input].length <= 5
  end

  def check_for_win
    return if search_array_for_win(@moves)
    return if search_array_for_win(get_horizontal_routes)
    return if search_array_for_win(get_diagonal_up_routes)
    search_array_for_win(get_diagonal_down_routes)
  end

  def search_array_for_win(arr)
    arr.each do |col|
      col.each_with_index do |_, i|
        next if col[i + 3].nil?
        if col[i..i + 3].all? { |elem| elem == GameUI::P1_COLOR }
          @winner = @player1
          return true
        elsif col[i..i + 3].all? { |elem| elem == GameUI::P2_COLOR }
          @winner = @player2
          return true
        end
      end
    end
    false
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

  def get_horizontal_routes
    rows = Array.new(6) { [] }
    6.times do |i|
      @moves.each { |col| rows[i].push(col[i]) }
    end
    rows
  end
end