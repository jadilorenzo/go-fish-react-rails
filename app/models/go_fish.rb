# frozen_string_literal: true

class GoFish
  attr_accessor :players, :deck, :round_count, :started_status, :round_results

  TOTAL_BOOKS = 13
  MAX_PLAYERS = 2
  def initialize(players = [], deck = Deck.new, started_status = false, round_count = 1, round_results = [])
    @players = players
    @deck = deck
    @started_status = started_status
    @round_count = round_count
    @round_results = round_results
  end

  def add_player(player)
    return if players.count >= MAX_PLAYERS

    players.push(player)
  end

  def empty?
    players.empty?
  end

  def go_fish
    return up_round if deck.cards.empty?

    card = turn_player.take_cards(deck.deal)
    card.rank
  end

  def play_round(rank, player_id)
    player = find_by_id(player_id)
    current_player = turn_player
    return if current_player === player

    handle_cards(current_player, rank, player)
    handle_emptiness
  end

  def play_bot_rounds
    while turn_player.instance_of?(BotPlayer)
      return if over?

      play_bot_round
    end
  end

  def play_bot_round
    rank = ask_bot_for_rank(turn_player.user_id)
    player_id = ask_bot_for_player(turn_player.user_id)
    play_round(rank, player_id)
  end

  def over?
    players.sum { |player| player.books.length } == TOTAL_BOOKS
  end

  def start
    deck.shuffle!
    determined_card_num.times { players.each { |player| player.take_cards(deck.deal) } }
    @started_status = true
  end

  def determined_card_num
    if players.length >= 4
      5
    elsif players.length <= 3
      7
    end
  end

  def turn_player
    turn = (@round_count - 1) % players.count
    players[turn]
  end

  def up_round
    @round_count += 1
  end

  def ready_to_start?
    return if started_status

    players.count >= 2
  end

  def find_player(name)
    players.find { |player| player.name == name }
  end

  def find_by_id(id)
    players.find { |player| player.user_id == id.to_i }
  end

  def return_opponent_names
    players.reject { |player| player == turn_player }.map(&:name)
  end

  def return_opponent_ids
    players.reject { |player| player == turn_player }.map(&:user_id)
  end

  def return_opponents(user)
    players.reject { |player| player == user }
  end

  def check_emptiness
    return unless turn_player.hand.empty?

    if turn_player.hand.empty? && deck.cards.empty?
      round_results.push("#{turn_player.name}'s hand is empty and the deck is empty! Next!")
      up_round
    elsif turn_player.hand_empty?
      round_results.push("#{turn_player.name} ran out of cards! Have one from the deck, on me!")
      turn_player.take_cards(deck.deal)
    end
  end

  def handle_emptiness
    check_emptiness until over? || !turn_player.hand.empty?
  end

  # tested in play_round
  def history
    round_results.shift until round_results.length <= (players.count + 2) if round_results.length > players.count
    round_results
  end

  def winner
    book_counts = players.map { |player| player.books.count }
    players.select { |people| people.books.count == book_counts.max }
  end

  def ask_bot_for_rank(bot_id)
    bot = find_by_id(bot_id)
    bot.select_rank
  end

  def ask_bot_for_player(bot_id)
    bot = find_by_id(bot_id)
    bot.select_player(return_opponent_ids)
  end

  def as_json
    {
      players: players.map(&:as_json),
      deck: deck.as_json,
      started_status: @started_status,
      round_results: @round_results,
      round_count: @round_count,
      turn_player: turn_player.as_json,
    }
  end

  def state_for(user_id, waiting_count, name)
    player = find_by_id user_id
    {
      currentUser: player.as_json,
      opponents: return_opponents(player).map(&:as_opponent_json),
      roundResults: history,
      startedStatus: started_status,
      waitingCount: waiting_count,
      name: name,
      turnId: turn_player.user_id,
      turnName: turn_player.name
    }
  end

  def self.dump(obj)
    obj.as_json
  end

  def self.from_json(json)
    json = json.with_indifferent_access
    players_from_json = json[:players].map do |player|
      (player[:user_id]).negative? ? BotPlayer.from_json(player) : Player.from_json(player)
    end
    deck_from_json = Deck.from_json(json[:deck])
    new(players_from_json, deck_from_json, json[:started_status], json[:round_count], json[:round_results])
  end

  def self.load(json)
    return if json.blank?

    from_json(json)
  end

  private # all of these are helper methods called during play_round

  def successful_take_message(current_player, rank, asked_player)
    round_results.push("#{current_player.name} took #{rank}'s from #{asked_player.name}!")
  end

  def failure_to_take_message(current_player, rank, asked_player)
    round_results.push("#{current_player.name} asked #{asked_player.name} for #{rank}'s. Go fish!")
  end

  def successful_fishing_message(current_player, rank)
    round_results.push("#{current_player.name} went fishing and succeeded in fishing a #{rank}!")
  end

  def failure_fishing_message(current_player)
    round_results.push("#{current_player.name} went fish and failed!")
  end

  def send_fishing(current_player, rank)
    if go_fish == rank
      successful_fishing_message(current_player, rank)
    else
      up_round
      failure_fishing_message(current_player)
    end
  end

  def handle_cards(current_player, rank, player)
    if player.has_rank?(rank)
      current_player.take_cards(player.give_cards(rank))
      successful_take_message(current_player, rank, player)
    elsif !player.has_rank?(rank)
      failure_to_take_message(current_player, rank, player)
      send_fishing(current_player, rank)
    end
  end
end
