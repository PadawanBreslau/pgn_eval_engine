class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :round_id
      t.boolean :is_finished

      t.timestamps
    end
  end
end
