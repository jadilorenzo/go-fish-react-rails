import Player from './Player'
import Deck from './Deck'
import Bot from './Bot'

class Game {
    constructor(game) {
        this.players = game.players
        this.deck = game.deck
        this.turn = 0
        this.cardsPerPerson = 7
    }

    gameOver() {
        const noCardsInHands = this.players
            .filter((player) => player.hand().length <= 0)
            .length > this.players.length - 1
        const emptyDeck = this.deck.length === 0
        return noCardsInHands && emptyDeck
    }
}

export default Game
