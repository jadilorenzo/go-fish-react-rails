# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoFish do
  describe '#add_player' do
    it 'adds player objects to an array' do
      game = GoFish.new
      expect { game }.not_to raise_error
      game.add_player(Player.new('Braden'))
      expect(game.players.count).to eq 1
      expect(game.players.first.name).to eq 'Braden'
    end
  end

  describe '#empty?' do
    it 'returns a boolean based on players being empty or not' do
      game = GoFish.new
      expect(game.empty?).to be true
      game.add_player('Josh')
      expect(game.empty?).to be false
    end
  end

  describe '#start' do
    it 'deals cards' do
      player1 = Player.new('Josh', user_id: 0)
      player2 = Player.new('Will', user_id: 1)
      player3 = Player.new('Braden', user_id: 2)
      game = GoFish.new([player1, player2, player3])
      hand_count = game.determined_card_num
      game.start
      game.players.each {|player| expect(player.hand_count).to eq hand_count}
      expect(game.deck.cards_left).to eq Deck.new.cards_left - hand_count * game.players.count
    end

    it 'deals 5 cards to 4 or more players' do
      players = [Player.new('Josh'), Player.new('Will'), Player.new('Braden'), Player.new('Caleb')]
      game = GoFish.new(players)
      hand_count = game.determined_card_num
      game.start
      expect(players[0].hand.count).to eq hand_count
      expect(players[1].hand.count).to eq hand_count
      expect(players[2].hand.count).to eq hand_count
      expect(game.deck.cards_left).to eq Deck.new.cards_left - hand_count * game.players.count
    end
  end

  describe '#turn_player' do
    it 'returns the proper turn player' do
      game = GoFish.new([Player.new('Josh'), Player.new('Braden')])
      expect(game.turn_player.name).to eq 'Josh'
      game.up_round
      expect(game.turn_player.name).to eq 'Braden'
    end
  end

  describe '#find_player' do
    it 'finds a player based off their name and returns the correct object' do
      game = GoFish.new([Player.new('Braden'), Player.new('Josh')])
      player1 = game.find_player('Braden')
      player2 = game.find_player('Josh')
      expect(player1.name).to eq 'Braden'
      expect(player2.name).to eq 'Josh'
    end
  end

  describe '#go_fish' do
    it 'has the player take a card when told to go fish' do
      game = GoFish.new([Player.new('John'), Player.new('Braden')])
      expect(game.players.first.hand).to be_empty
      game.go_fish
      expect(game.players.first.hand).not_to be_empty
    end

    it 'handles an empty deck' do
      game = GoFish.new([Player.new('Josh'), Player.new('Braden')], Deck.new([]))
      expect(game.turn_player.name).to eq 'Josh'
      game.go_fish
      expect(game.turn_player.name).to eq 'Braden'
    end
  end

  describe '#play_round' do
    context 'with only human players' do

      it 'takes an opponent\'s card when there are matching cards' do
        game = GoFish.new([Player.new('John', [Card.new('Ace', 'S')], user_id: 0), Player.new('Braden', [Card.new('Ace', 'C')], user_id: 1)])
        game.started_status = true
        game.play_round('Ace', '1')
        expect(game.players.last.hand).to be_empty
        expect(game.players.first.hand).to match_array [Card.new('Ace', 'S'), Card.new('Ace', 'C')]
        expect(game.history).to eq ['John took Ace\'s from Braden!']
      end

      it 'makes a player go fish if their opponent does not have the card they asked for' do
        game = GoFish.new([Player.new('John', [Card.new('Ace', 'S')]), Player.new('Braden', [Card.new('9', 'C')], user_id: 1)])
        game.started_status = true
        expect(game.turn_player.name).to eq 'John'
        game.play_round('Ace', '1')
        expect(game.turn_player.name).to eq 'Braden'
        expect(game.history).to eq ["John asked Braden for Ace's. Go fish!", "John went fish and failed!"]
      end

      it 'allows a player go fish and pickup the card they asked for' do
        game = GoFish.new([Player.new('John', [Card.new('2', 'S')]), Player.new('Braden', [Card.new('9', 'C')], user_id: 1)])
        game.started_status = true
        game.play_round('2', '1')
        expect(game.turn_player.name).to eq 'John'
        expect(game.turn_player.hand).to match_array [Card.new('2', 'S'), Card.new('2', 'C')]
        expect(game.history).to eq ["John asked Braden for 2's. Go fish!", "John went fishing and succeeded in fishing a 2!"]
      end
    end

    context 'with bot players' do
      it 'takes an opponent\'s card when there are matching cards' do
        bot = BotPlayer.new( 'Name', [Card.new('2', 'S')], user_id: -1)
        game = GoFish.new([bot, Player.new('John', [Card.new('2', 'D')], user_id: 0), Player.new('Braden', [Card.new('2', 'C')], user_id: 1)])
        game.started_status = true
        game.play_bot_round
        expect(game.history.count).to eq 1
        expect(game.history.first).to match (/took 2's from/)
      end
    end
  end

  context 'bot interaction' do
    describe '#ask_bot_for_rank' do
      it 'returns a random rank from the bot\'s hand' do
        bot = BotPlayer.new( 'Name', [Card.new('2', 'S')], user_id: -1)
        game = GoFish.new([Player.new('John', [Card.new('4', 'S')]), Player.new('Braden', [Card.new('6', 'C')], user_id: 1), bot])
        selected_rank = game.ask_bot_for_rank(bot.user_id)
        expect(['2', '9'].include?(selected_rank)).to be true
      end
    end

    describe '#ask_bot_for_player' do
      it 'returns a random player' do
        bot = BotPlayer.new(user_id: -1)
        game = GoFish.new([bot, Player.new('John', [Card.new('4', 'S')]), Player.new('Braden', [Card.new('6', 'C')], user_id: 1)])
        selected_player = game.ask_bot_for_player(bot.user_id)
        expect([0, 1].include?(selected_player)).to be true
      end
    end
  end

  describe '#over?' do
    it 'returns true when all 13 books have been collected' do
      game = GoFish.new([Player.new('Josh', [] ,%w(2 3 4 5 6 7 8 9 10)), Player.new('Braden',[] , %w(J Q K A))])
      expect(game.over?).to be true
    end

    it 'returns false when only a portion of books have been collected' do
      game = GoFish.new([Player.new('Josh', [] ,%w(2 3 4 5 6 7 8 9 )), Player.new('Braden',[] , %w(J Q A))])
      expect(game.over?).to be false
    end
  end

  describe '#return_opponent_names' do
    it 'returns only the player opponents' do
      game = GoFish.new([Player.new('Josh'), Player.new('Braden'), Player.new('William'), Player.new('Jeremy')])
      expect(game.return_opponent_names).to eq ['Braden', 'William', 'Jeremy']
    end
  end

  describe '#check_emptiness' do
    it 'ups the round when the deck is empty' do
      game = GoFish.new([Player.new('Josh'), Player.new('Braden')], Deck.new([]))
      expect(game.round_count).to eq 1
      game.check_emptiness
      expect(game.round_count).to eq 2
      expect(game.history).to eq ["Josh's hand is empty and the deck is empty! Next!"]
    end

    it 'Adds a card to the player\'s hand when it\'s empty' do
      game = GoFish.new([Player.new('Josh'), Player.new('Braden')], Deck.new([Card.new('Ace', 'S')]))
      expect(game.round_count).to eq 1
      game.check_emptiness
      expect(game.round_count).to eq 1
      expect(game.players.first.hand).to eq [Card.new('Ace', 'S')]
      expect(game.history).to eq ["Josh ran out of cards! Have one from the deck, on me!"]
    end

    it 'does an early return when player hand is not empty' do
      game = GoFish.new([Player.new('Josh', [Card.new('Ace', 'C')]), Player.new('Braden')], Deck.new([]))
      expect(game.round_count).to eq 1
      game.check_emptiness
      expect(game.round_count).to eq 1
      expect(game.players.first.hand).to eq [Card.new('Ace', 'C')]
    end
  end

  describe '#winner' do
    it 'returns the player with the most books' do
      game = GoFish.new([Player.new('Braden', [], ['2', '3', '4', '5', '6', '7', '8', '9', '10']), Player.new('Josh', [], ['Jack', 'Queen', 'King', 'Ace'])])
      expect(game.winner.first.name).to eq 'Braden'
    end
  end

  describe '#dump' do
    it 'turns the game logic into a JSON Object' do
      go_fish = GoFish.new([Player.new('Braden'), Player.new('Josh')], Deck.new([Card.new('Ace', 'H')]))
      expect(GoFish.dump(go_fish)).to eq (
        {
          :deck=> {:cards=>[{:rank=>"Ace", :suit=>"H"}]},
          :players => [{name: 'Braden', hand: [], books: [], user_id: 0}, {name: 'Josh', hand: [], books: [], user_id: 0}],
          :round_count => 1,
          :round_results => [],
          :started_status => false,
          :turn_player => {name: 'Braden', hand: [], books: [], user_id: 0}
        }
      )
    end
  end

      describe '#load' do
        it 'returns a JSON object as Ruby' do
          go_fish = GoFish.new([Player.new('Braden'), Player.new('Josh')], Deck.new([Card.new('Ace', 'H')]))
          fish_json = GoFish.dump(go_fish)
          game = GoFish.load(fish_json)
          expect(go_fish.players == game.players).to be true
          expect(go_fish.deck == game.deck).to be true
        end
      end
    end
