class MinesweeperBoard < ApplicationRecord
  # Trigger board generation before saving the record to the database
  before_save :generate_board
  validate :max_mines_validate

  private

  def generate_board
    # Initialize a blank board with the given dimensions
    board = Array.new(board_height) { Array.new(board_width, 0) }

    # Place mines randomly on the board
    mines_placed = 0
    while mines_placed < mines
      row = rand(board_height)
      col = rand(board_width)

      # Only place a mine if the cell is empty (0)
      if board[row][col] == 0
        board[row][col] = "Boom"  # or another marker for a mine
        mines_placed += 1
      end
    end

    # Convert board to JSON format for storage
    self.board_data = board.to_json
  end
  def max_mines_validate
    max_mines = board_height * board_width
    if mines.present? && mines > max_mines
      errors.add(:mines,  "Cannot generate Minesweeper Board!, the total number of cells (#{max_mines}) on the boards")
    end
  end
end
