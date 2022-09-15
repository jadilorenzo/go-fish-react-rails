import Player from './Player'

class Bot extends Player {
    constructor(name = '') {
        super(name === '' ? 'Billy Bob' : name)
    }

    isBot() {
        return true
    }
}

export default Bot
