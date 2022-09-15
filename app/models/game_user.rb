# frozen_string_literal: true 

class GameUser < ApplicationRecord
  belongs_to :user 
  belongs_to :game

  def self.finished_games_count
    self.group('user').where(finished: true).order(count_id: :desc).count(:id)
  end

  def self.wins_count
    self.group('user').where(winner: true).order(count_id: :desc).count(:id)
  end

  def self.time_played
    game_users_with_game = self.joins(:game).where(finished: true).select(:user_id, :'games.started_at', :'games.finished_at')
    time_and_player = {}
    game_users_with_game.map do |game|
      user = User.where(id: game.user_id).first
      time = time_and_player.fetch(user, 0) + (game.finished_at - game.started_at)
      time_and_player[user] = time
    end
    time_and_player.to_a.sort_by {|item| [-item[1], item[0]]}.to_h 
  end

  def self.win_percentage
    games, wins = finished_games_count, wins_count
    users_with_percentage = {}
    games.each do |user, game_count|
      win_rate = wins.fetch(user, 0)
      users_with_percentage[user] = (win_rate / game_count.to_f*100).to_i
    end
    users_with_percentage.to_a.sort_by {|item| [-item[1], item[0]]}.to_h 
  end
end
