class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name 
      t.integer :player_count, default: 2
      
      t.timestamps
    end
  end
end
