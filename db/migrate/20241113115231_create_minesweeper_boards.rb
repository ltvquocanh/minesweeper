class CreateMinesweeperBoards < ActiveRecord::Migration[7.2]
  def change
    create_table :minesweeper_boards do |t|
      t.string :email
      t.string :board_name
      t.integer :board_width
      t.integer :board_height
      t.integer :mines
      t.text :board_data

      t.timestamps
    end
  end
end
