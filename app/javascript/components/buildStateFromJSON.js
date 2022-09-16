import {
    GameModel,
    PlayerModel,
    CardModel,
    DeckModel
} from '../models'

const jsonRankToCardRank = {
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "6": "6",
    "7": "7",
    "8": "8",
    "9": "9",
    "10": "10",
    "Jack": "J",
    "Queen": "Q",
    "King": "K",
    "Ace": "A"
}

const buildStateFromJSON = ({ game, user }) => {
    if (!game.go_fish) {
        return {}
    }

    const hand = (player) => (
        player.hand.map((card) => (
            new CardModel({
                rank: jsonRankToCardRank[card.rank],
                suit: card.suit,
            })
        ))
    )

    const players = (game) => (
        game.go_fish.players.map((player) => (
            new PlayerModel({
                name: player.name,
                books: player.books,
                hand: hand(player),
                id: player.user_id,
                user: user
            })
        ))
    )

    const deck = (game) => (
        new DeckModel({
            cards: game.go_fish.deck.cards.map((card) => {
                new CardModel({ ...card })
            })
        })
    )

    const gameModel = new GameModel({
        name: game.name,
        players: players(game),
        deck: deck(game),
        roundResults: game.go_fish.round_results
    })

    const turnPlayer = game.go_fish.turn_player

    const player = gameModel.players.filter((player) => (
        player.isYou()
    ))[0]

    return {
        game: gameModel,
        turnPlayer,
        user,
        player
    }
}

export default buildStateFromJSON
