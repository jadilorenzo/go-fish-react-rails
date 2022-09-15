import PropTypes from 'prop-types'
import React, { Component } from 'react'

export default class Player extends Component {
    constructor(props) {
        super(props)
        this.props = props
    }

    static propTypes = {
        onAsk: PropTypes.func.isRequired,
        player: PropTypes.any.isRequired,
        index: PropTypes.number.isRequired,
        cardSelected: PropTypes.bool.isRequired
    }

    render() {
        return (
            <div>
                <div>
                    <div>{this.props.player.name}</div>
                    <div>{this.props.player.isBot() || "(you)"}</div>
                </div>
                <div>{this.props.player.hand().length} card{this.props.player.hand().length === 1 || 's'}</div>
                <div>{this.props.player.books().map((book) => (
                    book[0].rank()
                )).join(', ')}</div>
                {(this.props.index !== 0 && this.props.cardSelected) ? (
                    <button role={`ask-${this.props.index}`}>Ask</button>
                ) : null}
            </div>
        )
    }
}
