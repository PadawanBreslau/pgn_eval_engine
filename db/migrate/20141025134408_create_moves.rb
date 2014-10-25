class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.integer :game_id
      t.integer :previous_move_id
      t.string :start_field
      t.string :end_field
      t.string :piece

      t.timestamps
    end
  end
end
