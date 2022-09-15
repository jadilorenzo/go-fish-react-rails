require 'rails_helper'

RSpec.describe GameUser, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, name: 'Josh', email: 'josh@example.com') }
  describe '#finished_games_count' do
    it 'returns the correct number of games' do
      50.times {create_finished_game(user1, [user2])}
      games = GameUser.finished_games_count
      games.values.each {|value| expect(value).to eq 50}
    end
  end
  
  describe '#wins_count' do
    it 'returns the correct number of wins' do
      50.times {create_finished_game(user1, [user2])}
      wins = GameUser.wins_count
      expect(wins).to eq user1=> 50
    end
  end

  describe '#win_percentage' do
    it 'returns the correct percentage' do
      50.times {create_finished_game(user1, [user2])}
      win_percentages = GameUser.win_percentage
      expect(win_percentages).to eq({user1=> 100, user2=>0})
    end
  end

  describe '#time_played' do
    it 'returns the time played' do
      50.times {create_finished_game(user1, [user2])}
      time_played = GameUser.time_played
    end
  end
  
  def create_finished_game(winner, losers)
    game = create(:game)
    game.users << winner
    losers.each { |loser| game.users << loser }
    game.start
    finish_game(game, winner)
  end
  
  def finish_game(game, winner)
    game.go_fish.deck.cards = []
    game.go_fish.players.each { |player| player.hand = [] }
    game.go_fish.find_by_id(winner.id).books = %w( 2 3 4 5 6 7 8 9 10 J Q K A )
    game.finish
    game.save
  end
end
