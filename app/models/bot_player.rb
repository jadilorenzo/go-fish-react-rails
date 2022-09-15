# frozen_string_literal: true 

class BotPlayer < Player
  attr_accessor :name, :hand, :books, :user_id
  def initialize(name = new_name, hand =[], books =[], user_id: -1)
    @name = name
    @user_id = user_id
    @hand = hand
    @books = books
  end
  
  def new_name
    Faker::Movies::StarWars.character 
  end
  
  def select_player(player_ids)
    player_ids.sample
  end
  
  def select_rank
    hand.uniq { |card| card.rank }.sample.rank
  end
end