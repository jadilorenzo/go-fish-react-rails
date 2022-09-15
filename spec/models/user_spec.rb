require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, name: 'Josh', email: 'josh@example.com') }
  describe 'valid user' do
    it 'checks that the user by default is valid' do
      expect(user1).to be_valid
    end
  end
  
  describe '#get_rival' do
    it 'returns the correct rival and game name' do
      50.times { create_finished_game(user1, [user2]) }
      user1_rival = user1.get_rival
      user2_rival = user2.get_rival
      expect(user1_rival).to eq({user2=>50})
      expect(user2_rival).to eq({user1=>50})
      expect(user1_rival).not_to eq({user1=>50})
      expect(user2_rival).not_to eq({user2=>50})
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