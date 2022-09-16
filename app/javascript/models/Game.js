class Game {
    constructor(game) {
        this.name = game.name
        this.players = game.players
        this.deck = game.deck
        this.roundResults = game.roundResults
    }

    gameOver() {
        const noCardsInHands = this.players
            .filter((player) => player.hand.length <= 0)
            .length > this.players.length - 1
        const emptyDeck = this.deck.length === 0
        return noCardsInHands && emptyDeck
    }
}

export default Game
