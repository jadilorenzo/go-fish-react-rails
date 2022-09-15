# frozen_string_literal: true

class Player
  attr_accessor :name, :hand, :books, :user_id
  def initialize(name = '', hand =  [], books = [], user_id: 0)
    @name = name
    @user_id = user_id
    @hand = hand
    @books = books
  end

  def format(result)
    result.gsub(name, 'You')
  end

  def take_cards(cards)
    hand.push(cards).flatten!
    check_for_books
    sort_hand!
    cards
  end

  def has_rank?(rank)
    hand.any? {|card| card.same_rank?(rank)}
  end

  def hand_count
    hand.count
  end

  def hand_empty?
    hand.empty?
  end

  def give_cards(rank)
    cards_to_give = hand.filter {|card| card.same_rank?(rank)}
    hand.delete_if {|card| cards_to_give.include?(card)}
    cards_to_give
  end

  def check_for_books
    hand.compact!
    card_ranks = hand.map {|card| card.rank}
    Card::RANKS.each do |rank|
      if card_ranks.count {|card_rank| rank == card_rank} == 4
        hand.delete_if {|card| card.rank == rank}
        books.push(rank)
      end
    end
  end

  def sort_hand!
    hand.sort!.compact!
  end

  def show_unique_cards
    hand.map {|card| card.rank}.uniq
  end

  def as_json
    {
      name: name,
      hand: hand.map(&:as_json),
      books: books,
      user_id: user_id,
    }
  end

  def self.from_json(json)
    hand_from_json = json[:hand].map {|card| Card.from_json(card)}
    self.new(json[:name], hand_from_json, json[:books], user_id: json[:user_id])
  end

  def ==(other)
    hand == other.hand && name == other.name && books == other.books
  end
end
