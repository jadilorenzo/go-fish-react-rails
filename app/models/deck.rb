# frozen_string_literal: true 

class Deck
  attr_accessor :cards
  def initialize(cards = build_deck)
    @cards = cards
  end

  def cards_left
    cards.length
  end

  def deal
    cards.shift
  end

  def shuffle!
    cards.shuffle!
  end

  def as_json
    {
      cards: cards.map(&:as_json)
    }
  end

  def self.from_json(json)
    new_cards = json[:cards].map {|card| Card.from_json(card)}
    self.new(new_cards)
  end
  
  def ==(other)
    cards == other.cards
  end

  private

  def build_deck
    Card::SUITS.flat_map do |suit|
      Card::RANKS.map do |rank|
        card = Card.new(rank, suit)
      end
    end
  end
end