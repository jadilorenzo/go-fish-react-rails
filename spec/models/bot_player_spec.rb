# frozen_string_literal: true 

RSpec.describe BotPlayer do
  describe 'Initialization' do
    it 'allows for a bot player to be created' do
      bot = BotPlayer.new(user_id: -1)
      expect(bot.books).to be_empty
      expect(bot.name).not_to be_nil
      expect(bot.hand).to be_empty
      expect(bot.user_id).to eq -1
    end
  end
  
  describe '#select_rank' do
    it 'returns a rank from it\'s hand' do
      bot = BotPlayer.new(user_id: -1)
      hand = [Card.new('Ace', 'D'), Card.new('5', 'S')]
      bot.hand = hand
      selected_rank = bot.select_rank
      expect(['Ace', '5'].include?(selected_rank)).to be true
    end
  end
  
  describe '#select_player' do
    it 'returns a random player id from the provided list' do
      bot = BotPlayer.new(user_id: -1)
      player_ids = [1, 2, 3, 4]
      selected = bot.select_player(player_ids)
      expect(player_ids.include?(selected)).to be true
    end
  end
end