import PropTypes from 'prop-types'
import React, { Component } from 'react'

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
        const id = `${card.suit()}_${card.rank()}`
        return (
            <div
                onClick={() => this.props.setRank({ rank: card.rank() })}
                className={`card ${rank === card.rank() ? 'card--selected' : ''}`}
            >
                <img
                    className='card--img'
                    src={card.rank() ? `/assets/${id}.svg` : undefined}
                    alt={id}
                />
            </div>
        )
    }
}
