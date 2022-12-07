require "./lib/game"
require "./lib/game_ui"
require "./lib/player"

describe Game do
  describe "#initialize" do
    it "makes @moves an array of 7 empty arrays" do
      game = described_class.new
      expect(game.moves).to eq([[], [], [], [], [], [], []])
    end
  end

  describe "#register_player" do
    context 'when registering a player named "Austin"' do
      subject(:reg_game) { described_class.new }
      before do
        player1 = "Austin"
        allow(reg_game).to receive(:gets).and_return(player1)
        reg_game.register_player
      end

      it "increases length of @players by 1" do
        expect { reg_game.register_player }
          .to change { reg_game.players.length }.by(1)
      end

      it "makes the last item in @players be a Player" do
        expect(reg_game.players.last).to be_a(Player)
      end

      it 'makes last item in @players have the name "Austin"' do
        expect(reg_game.players.last.name).to eq("Austin")
      end
    end
  end

  describe "#determine_starting_player" do
    before :all do
      @starting_player_game = described_class.new
      add_players(@starting_player_game)
    end

    it "assigns a player to @player1" do
      expect(@starting_player_game.player1).not_to be_nil
    end

    it "assigns a player to @player2" do
      expect(@starting_player_game.player2).not_to be_nil
    end

    it "assigns @player1 the color red" do
      expect(@starting_player_game.player1.color).to eq("red")
    end

    it "assigns @player2 the color blue" do
      expect(@starting_player_game.player2.color).to eq("blue")
    end
  end

  describe "#check_for_win" do
    context "when there is a set of winning moves" do
      subject(:game) { described_class.new }
      it "makes @player1 the winner if the winning sequence is red" do
        add_players(game)
        moves = Array.new(7) { [] }
        4.times { moves[0].push("red") }
        game.moves = moves
        game.check_for_win
        expect(game.winner).to eq(game.player1)
      end

      subject(:player2_wins) { described_class.new }
      it "makes @player2 the winner if the winning sequence is blue" do
        add_players(player2_wins)
        player2_win_moves = Array.new(7) { [] }
        4.times { player2_win_moves[0].push("blue") }
        player2_wins.moves = player2_win_moves
        player2_wins.check_for_win
        expect(player2_wins.winner).to eq(player2_wins.player2)
      end

      subject(:horizontal_win) { described_class.new }
      it "properly evaluates horizontal wins" do
        add_players(horizontal_win)
        moves = Array.new(7) { [] }
        moves[0].push("red", "blue")
        moves[1].push("blue", "blue")
        moves[2].push("red", "blue")
        moves[3].push("red", "blue")
        horizontal_win.moves = moves
        horizontal_win.check_for_win
        expect(horizontal_win.winner).to eq(horizontal_win.player2)
      end

      subject(:diag_up_win) { described_class.new }
      it "properly evaluates up diagonal wins" do
        add_players(diag_up_win)
        moves = Array.new(7) { [] }
        moves[0].push("red")
        moves[1].push("blue", "red")
        moves[2].push("red", "blue", "red")
        moves[3].push("red", "blue", "blue", "red")
        diag_up_win.moves = moves
        diag_up_win.check_for_win
        expect(diag_up_win.winner).to eq(diag_up_win.player1)
      end

      subject(:diag_down_win) { described_class.new }
      it "properly evaluates down diagonal wins" do
        add_players(diag_down_win)
        moves = Array.new(7) { [] }
        moves[0].push("red", "blue", "blue", "red")
        moves[1].push("red", "blue", "red")
        moves[2].push("blue", "red")
        moves[3].push("red")
        diag_down_win.moves = moves
        diag_down_win.check_for_win
        expect(diag_down_win.winner).to eq(diag_down_win.player1)
      end
    end

    context "when there is not a set of winning moves" do
      subject(:no_winner) { described_class.new }
      it "@winner is nil" do
        add_players(no_winner)
        no_winner.check_for_win
        expect(no_winner.winner).to be_nil
      end
    end
  end

  describe "#verify_input" do
    subject(:verify_inp) { described_class.new }

    context "when input is valid" do
      before do
        valid_inp = "3"
        allow(verify_inp).to receive(:gets).and_return(valid_inp)
      end
      it "returns input - 1 as integer" do
        moves = Array.new(7) { [] }
        verify_inp.moves = moves
        expect(verify_inp.get_player_move).to eq(2)
      end
    end

    context "when input is not valid" do
      before do
        letter = "a"
        valid = "3"
        allow(verify_inp).to receive(:gets).and_return(letter, valid)
      end
      it "returns error once" do
        moves = Array.new(7) { [] }
        verify_inp.moves = moves
        expect(verify_inp)
          .to receive(:puts)
                .with("Input error! Please enter a non-full column number (0-6)")
                .once
        verify_inp.get_player_move
      end
    end
  end

  describe "#get_player_move" do
    context "when a valid move is submitted" do
      before do
        @move_game = described_class.new
        add_players(@move_game)
      end

      it "returns that move" do
        col_selection = "3"
        allow(@move_game).to receive(:gets).and_return(col_selection)
        expect(@move_game.get_player_move).to eq(col_selection.to_i - 1)
      end
    end

    context "when an invalid move then a valid move is submitted" do
      subject(:input_err) { described_class.new }
      before do
        add_players(input_err)
        valid_inp = "3"
        letter = "a"
        allow(input_err).to receive(:gets).and_return(letter, valid_inp)
      end

      it "throws an error once" do
        error_msg = "Input error! Please enter a non-full column number (0-6)"
        expect(input_err).to receive(:puts).with(error_msg).once
        input_err.get_player_move
      end
    end
  end

  describe "#take_turn" do
    subject(:turn_game) { described_class.new }

    context "when a valid move is submitted" do
      before do
        move = "3"
        allow(turn_game).to receive(:gets).and_return(move)
      end

      it "adds the move to the @moves array" do
        add_players(turn_game)
        player = turn_game.player1
        turn_game.take_turn(player)
        expect(turn_game.moves[2][0]).to eq(player.color)
      end

      it "increases the player's turns_taken by 1" do
        add_players(turn_game)
        player = turn_game.player1
        turn_game.take_turn(player)
        expect(turn_game.player1.turns_taken).to eq(1)
      end
    end

  end

  describe "#play_game" do
    subject(:won_game) { described_class.new }

    context "when there's a winner" do
      it "displays a message showing the winner" do
        add_players(won_game)
        won_game.winner = won_game.player1
        expect(won_game).to receive(:puts).with("#{won_game.winner.name} wins!")
        won_game.play_game
      end
    end
  end
end

def add_players(game)
  players = []
  players.push(Player.new("Austin"))
  players.push(Player.new("Bob"))
  game.players = players
  game.determine_starting_player
end
