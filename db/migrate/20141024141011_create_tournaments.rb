class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :url
      t.boolean :is_finished
      t.timestamps
    end
  end
end
