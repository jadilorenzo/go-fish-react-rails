# frozen_string_literal: true 

class User < ApplicationRecord
  has_many :game_users
  has_many :games, through: :game_users
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def get_rival
    games = Game.joins(:game_users).where(game_users: { user_id: id}).select(:id).map { |game| game.id }
    opponents = User.joins(:games).where(games: {id: games}).order(count_id: :desc).group(:id).count(:id)
    opponents.delete(id)
    rival = opponents.shift
    [[User.find(rival[0]), rival[1]]].to_h
  end
end
