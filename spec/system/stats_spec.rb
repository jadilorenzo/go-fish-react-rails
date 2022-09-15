# frozen_string_literal: true 

RSpec.describe 'Stats page' do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, name: 'Josh', email: 'josh@example.com') }
  describe 'Games Played' do
    it 'Shows the global number of games played' do
      login(user1)
      50.times {create_finished_game(user1, [user2])}
      click_on 'Stats'
      expect(page).to have_content("You: #{user1.games.count} Games")
    end
  end

  describe 'Win %' do
    it 'returns the correct win percentage on the game' do
      login(user1)
      50.times {create_finished_game(user1, [user2])}
      click_on 'Stats'
      expect(page).to have_content("You: 100%")
    end
  end
  
  def login(user)
    visit root_path 
    fill_in 'Email', with: user.email 
    fill_in 'Password', with: user.password 
    click_on 'Login'
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