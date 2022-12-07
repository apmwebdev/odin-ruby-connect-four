# frozen_string_literal: true

class GameUI
  GAME_PIECE = "\u2b24"
  P1_COLOR = "red"
  P1_COLOR_CODE = "91"
  P2_COLOR = "blue"
  P2_COLOR_CODE = "94"
  BLANK_COLOR_CODE = "97"

  def render_game(moves)
    rows = create_rows(moves)
    puts "1  2  3  4  5  6  7"
    until rows.empty?
      puts rows.pop.join(" ")
    end
  end

  def create_rows(moves)
    rows = Array.new(6) { [] }
    rows.each_with_index do |row, row_i|
      moves.each do |col|
        item = col[row_i]
        if item == P1_COLOR
          row.push(p1_piece)
        elsif item == P2_COLOR
          row.push(p2_piece)
        else
          row.push(blank_piece)
        end
      end
    end
    rows
  end

  def clear_screen
    (system "clear") || (system "cls")
  end

  def p1_piece
    "\e[#{P1_COLOR_CODE}m#{GAME_PIECE} \e[0m"
  end

  def p2_piece
    "\e[#{P2_COLOR_CODE}m#{GAME_PIECE} \e[0m"
  end

  def blank_piece
    "\e[#{BLANK_COLOR_CODE}m#{GAME_PIECE} \e[0m"
  end

end
