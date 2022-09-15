class AddTimeStampsToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :started_at, :datetime
    add_column :games, :finished_at, :datetime
  end
end
