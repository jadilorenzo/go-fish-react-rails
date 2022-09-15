import PropTypes from 'prop-types'
import React, { Component } from 'react'

export default class Card extends Component {
    constructor(props) {
        super(props)
        this.props = props
    }

    static propTypes = {
        card: PropTypes.any.isRequired,
        setRank: PropTypes.func.isRequired
    }

    render() {
        const {card} = this.props
        const id = `${card.suit()}_${ card.rank()}`
        return (
            <div

                onClick={() => this.props.setRank({ rank: card.rank() })}
            >
                <img src={`${id}.svg`} alt={id}/>
            </div>
        )
    }
}
