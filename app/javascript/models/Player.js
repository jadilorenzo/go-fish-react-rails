const random = (max, min) => Math.floor(Math.random() * (max - min) + min)
const rankValues = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

class Player {
    constructor({name, hand, books, id, user}) {
        this.name = name || 'name'
        this.hand = hand || [] // array of cards
        this.books = books || []// array of strings
        this.id = id || 0
        this.user = user || 0
    }

    isBot() {
        return this.id > 0
    }

    isYou() {
        return this.id === this.user.id
    }
}

export default Player
