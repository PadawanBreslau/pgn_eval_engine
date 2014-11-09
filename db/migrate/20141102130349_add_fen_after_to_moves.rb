class AddFenAfterToMoves < ActiveRecord::Migration
  def change
    add_column :moves, :fen_after, :string
  end
end
