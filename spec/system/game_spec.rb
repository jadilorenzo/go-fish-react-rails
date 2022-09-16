require 'rails_helper'

RSpec.describe 'Game', :js, type: :system do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user, name: 'Josh', email: 'josh@example.com') }
  describe 'Create Game' do
    it 'successfully creates a game' do
      login(user1)
      click_on 'Create Game'
      fill_in 'Name', with: 'Braden\'s game'
      select '2', from: 'Player count'
      click_on 'Create'
      expect(page).to have_content('Waiting on 1 player...')
    end
  end

  describe 'Join Game' do
    it 'Allows the user to successfully join a game' do
      game = create(:game, :two_players)
      login(user2)
      expect(page).to have_content('Game 1')
      click_on 'Game 1'
      click_on 'Go Fish' # Allows for rejoining of game if you back out
      click_on 'Game 1'
      expect(page.current_path).to eq "/games/#{game.id}"
    end
  end

  describe 'Playing a game' do
    it 'shows the correct content of a game' do
      create(:game, :two_players, name: 'Test based')
      login(user2)
      click_on 'Test based'
      expect(page).to have_content('Players')
      expect(page).to have_content('Round Results')
      expect(page).to have_content('Hand')
    end

    it 'Can play a round', :js do
      new_game = create(:game, :two_players, name: 'Test based')
      login(user2)
      click_on 'Test based'
      sleep 0.01
      game = Game.find(new_game.id)

      game.go_fish.players.first.hand = [Card.new('Ace', 'S')]
      game.go_fish.players.last.hand = [Card.new('Ace', 'H'), Card.new('7', 'D')]
      game.save
      visit game_path(game)
      page.first('.card-image').click
      sleep 0.01
      click_on 'Ask'
      sleep 0.01
      game = Game.find(new_game.id)
      expect(game.go_fish.players.first.hand).to eq [Card.new('Ace', 'S'), Card.new('Ace', 'H')]
      expect(page).to have_css('img', class: 'card-image', count: 2)
    end
  end

  def login(user)
    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Login'
  end
end
