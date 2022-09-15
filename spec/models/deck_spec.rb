# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Deck do
  describe '#initialize' do
    it 'initializes a deck with 52 cards' do
      deck = Deck.new
      expect(deck.cards_left).to eq 52
    end

    it 'allows for the user to build a deck using one card, should they want to' do
      deck = Deck.new([Card.new('Ace', 'S')])
      expect(deck.cards_left).to eq 1
    end
  end

  describe '#deal' do
    it 'allows the deck to deal one card (and get the correct output)' do
      deck = Deck.new
      expect(deck.deal).to eq Card.new('2', 'C')
      expect(deck.cards_left).to eq 51
    end
  end

  describe '#shuffle' do
    it 'allows the deck to be shuffled' do
      deck1 = Deck.new
      deck2 = Deck.new
      expect(deck1.shuffle!).not_to eq(deck2.cards)
      expect(deck1.shuffle!).to match_array deck2.cards
    end
  end

  describe '#as_json' do
    it 'turns all cards in the deck into JSON Objects' do
      deck = Deck.new([Card.new('Ace', 'S'), Card.new('Ace', 'H')])
      expect(deck.as_json).to eq(:cards => [{:rank => 'Ace', :suit => 'S'}, {:rank => 'Ace', :suit => 'H'}])
    end
  end

  describe '#from_json' do
    it 'returns the deck object from JSON to a ruby object' do
      deck = Deck.new([Card.new('Ace', 'S'), Card.new('Ace', 'H')])
      json = deck.as_json 
      expect(Deck.from_json(json)).to eq deck
    end
  end
end