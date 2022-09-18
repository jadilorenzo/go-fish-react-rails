import PropTypes from 'prop-types'
import React, { Component } from 'react'

const textToImgRank = {
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

export default class Card extends Component {
    constructor(props) {
        super(props)
        this.props = props
    }

    static propTypes = {
        card: PropTypes.any.isRequired,
        setRank: PropTypes.func.isRequired,
        rank: PropTypes.string.isRequired
    }

    render() {
        const {card, rank} = this.props
        const id = `${card.suit}_${textToImgRank[card.rank]}`

        return (
            <div
                onClick={() => this.props.setRank({ rank: card.rank })}
                className={`card ${rank === card.rank ? 'card--selected' : ''}`}
            >
                <img
                    className='card--img card-image'
                    src={card.rank ? `/assets/${id}.svg` : undefined}
                    alt={id}
                />
            </div>
        )
    }
}
