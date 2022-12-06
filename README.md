# odin-ruby-connect-four

## Game class
vars: board, players, moves, winner, player1, player2

### initialize
- Create board, initialize it (7x6)
- players array empty
- moves - array of empty colum arrays
- winner variable. Assigned later from players

### start_game
- register_player x2
- determine_starting_player
- puts first player
- render_board
- play_game

### register_player
puts prompt
Create new player and add to players array

### determine_starting_player
randomly assign @player1 from players array
@player1.goes_first = true
player2 is other player
player1.color = red
player2.color = black

### play_game
loop take_turn until winner

### take_turn
get player input (separate method)
validate input
update moves
increase player turns_taken
render board

### get_player_move
Should be similar to `player_input` from exercises:
```ruby
def player_input(min, max)
    loop do
      user_input = gets.chomp
      verified_number = verify_input(min, max, user_input.to_i) if user_input.match?(/^\d+$/)
      return verified_number if verified_number

      puts "Input error! Please enter a number between #{min} or #{max}."
    end
  end

  def verify_input(min, max, input)
    return input if input.between?(min, max)
  end
```

### check_for_win
checks for win