# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card do
  describe 'valid initialization' do
    it 'allows for valid ranks and suits' do
      card = Card.new('Ace', 'S')
      expect(card.rank).to eq 'Ace'
      expect(card.suit).to eq 'S'
    end

    it 'tests the ranks if they are the same' do
      card1 = Card.new('Ace', 'S')
      card2 = Card.new('Ace', 'C')
      expect(card1).to be_same_rank(card2.rank)
    end
  end

  describe 'invalid initialization' do
    it 'does not allow for incorrect suits and ranks' do
      card = Card.new('Test', 'Test')
      expect(card.rank).to be_nil
      expect(card.suit).to be_nil
    end
  end

  describe '#as_json' do
    it 'turns cards into their JSON format' do
      card1 = Card.new('Ace', 'S')
      card2 = Card.new('Ace', 'H')
      expect(card1.as_json).to eq({:rank=>"Ace", :suit=>"S"})
      expect(card2.as_json).to eq({:rank=>"Ace", :suit=>"H"})
    end
  end

  describe '#from_json' do
    it 'turns a card from JSON to Ruby formatting' do
      card1 = Card.new('Ace', 'S')
      card2 = Card.new('Ace', 'H')
      json1 = card1.as_json
      json2 = card2.as_json
      expect(Card.from_json(json1)).to eq Card.new('Ace', 'S')
      expect(Card.from_json(json2)).to eq Card.new('Ace', 'H')
    end
  end
end