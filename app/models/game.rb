# frozen_string_literal: true

class Game < ApplicationRecord
  validates :name, presence: true
  validates :player_count, presence: true, numericality: {only_integer: true, less_than_or_equal_to: 5, greater_than_or_equal_to: 2}
  validates :bot_count, presence: true, numericality: {only_integer: true, less_than_or_equal_to: 4, greater_than_or_equal_to: 0}
  has_many :game_users
  has_many :users, through: :game_users

  serialize :go_fish, GoFish

  def user_count
    users.count
  end

  def ready?
    waiting_count <= 0
  end

  def less_than_max
    users.count < player_count
  end

  def play_round(rank, askee_id)
    go_fish.play_round(rank, askee_id)
    go_fish.play_bot_rounds
    if go_fish.over? && !finished?
      finish
    end
    self.save
  end

  def ready_to_start?
    less_than_max
  end

  def waiting_count
    player_count - (user_count + bot_count)
  end

  def start
    if player_count == user_count + bot_count
      players = users.map {|user| Player.new(user.name, user_id: user.id)}
      bot_players = (1..bot_count).to_a.map { |num| BotPlayer.new(user_id: -num) }
      go_fish_game = GoFish.new(players + bot_players)
      go_fish_game.start
      update(go_fish: go_fish_game, started_at: Time.zone.now)
    end
  end

  def finished?
    finished_at.present?
  end

  def finish
    self.finished_at = Time.zone.now
    game_users.update_all(finished: true)
    game_users.where(user_id: go_fish.winner.map{|winner| winner.user_id}).update_all(winner: true)
  end

  def as_json
    {
      id: id,
      player_count: player_count,
      bot_count: bot_count,
      go_fish: go_fish.as_json,
      waiting_count: waiting_count
    }
  end

  def game_not_started
    {
        id: id,
        name: name,
        started: false,
        waitingCount: waiting_count,
    }
  end

  def state_for(user_id)
    go_fish != nil ? go_fish.state_for(user_id, waiting_count, name, id) : game_not_started
  end
end
