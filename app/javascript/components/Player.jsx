import PropTypes from 'prop-types'
import React, { Component } from 'react'

export default class Player extends Component {
    constructor(props) {
        super(props)
        this.props = props
    }

    static propTypes = {
        onAsk: PropTypes.func,
        player: PropTypes.object.isRequired,
        cardSelected: PropTypes.bool,
        isYourTurn: PropTypes.bool,
        isCurrentPlayer: PropTypes.bool.isRequired,
        you: PropTypes.bool
    }

    render() {
        const { player, cardSelected, isYourTurn, isCurrentPlayer, you } = this.props
        return (
            <div className='player paper-border'>
                <div className={`player--section ${isCurrentPlayer ? 'bold' : ''}`}>
                    <span>{player.name}</span>
                    <span>{!you || " (you)"}</span>
                    {you || <span>{player.handCount} card{player.handCount === 1 || 's'}</span>}
                </div>

                <div className='player--section'>
                    <div>{player.books.join(', ')}</div>
                    {(!you && cardSelected && isYourTurn) ? (
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
