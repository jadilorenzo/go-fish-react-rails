import PropTypes from 'prop-types'
import React, { Component } from 'react'

export default class Player extends Component {
    constructor(props) {
        super(props)
        this.props = props
    }

    static propTypes = {
        onAsk: PropTypes.func.isRequired,
        player: PropTypes.object.isRequired,
        cardSelected: PropTypes.bool.isRequired
    }

    render() {
        const { player, index, cardSelected } = this.props
        return (
            <div className='player paper-border'>
                <div className='player--section'>
                    <span>{player.name}</span>
                    <span>{!player.isYou() || " (you)"}</span>
                    <span>{player.hand.length} card{player.hand.length === 1 || 's'}</span>
                </div>

                <div className='player--section'>
                    <div>{player.books.join(', ')}</div>
                    {(index !== 0 && cardSelected) ? (
                        <button
                            className='btn-primary'
                            onClick={() => this.props.onAsk({ id: player.id })}
                            role={`ask-${player.id}`}
                        >Ask</button>
                    ) : null}
                </div>
            </div>
        )
    }
}
