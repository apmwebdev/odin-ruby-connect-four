# frozen_string_literal: true

require "./lib/game_ui"

describe GameUI do
  describe "#render_game" do
    subject(:game_ui) { described_class.new }

    it "renders rows in reverse order" do
      row1 = %w[a a a a a a]
      row1_as_str = "a a a a a a a"
      row2 = %w[b b b b b b]
      row2_as_str = "b b b b b b b"
      rows = [row1, row2]
      column_header_row = "1  2  3  4  5  6  7"
      allow(game_ui).to receive(:create_rows).and_return(rows)
      expect(game_ui)
        .to receive(:puts)
              .and_return(column_header_row, row2_as_str, row1_as_str)
      game_ui.render_game(rows)
    end
  end

  describe "#create_rows" do
    subject(:game_ui) { described_class.new }

    it "properly creates rows based on input" do
      expect(game_ui.create_rows(create_rows_input)).to eq(create_rows_output)
    end
  end
end


def create_rows_input
  [
    %w[red red red red red red],
    %w[blue blue blue blue blue blue],
    %w[red red red red red red],
    %w[blue blue blue blue blue blue],
    %w[red red red red red red],
    %w[blue blue blue blue blue blue],
    []
  ]
end

def create_rows_output
  game_ui = GameUI.new
  p1_piece = game_ui.p1_piece
  p2_piece = game_ui.p2_piece
  blank_piece = game_ui.blank_piece
  return_arr = Array.new(6) { [] }
  return_arr.each do |row|
    3.times { row.push(p1_piece, p2_piece) }
    row.push(blank_piece)
  end
  return_arr
end
