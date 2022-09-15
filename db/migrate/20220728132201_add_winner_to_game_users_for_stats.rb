class AddWinnerToGameUsersForStats < ActiveRecord::Migration[7.0]
  def change
    add_column :game_users, :winner, :boolean, default: false
    add_column :game_users, :finished, :boolean, default: false
  end
end
