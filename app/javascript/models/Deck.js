// DA DK DQ DJ D10... HA HK HQ...
class Deck {
    constructor({cards}) {
        this.cards = cards
    }

    get length() {
        return this.cards.length
    }

    empty() {
        return this.cards.length === 0
    }

    cards() {
        return this.cards
    }
}

export default Deck
