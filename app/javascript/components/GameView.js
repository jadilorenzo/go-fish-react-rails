import PropTypes from 'prop-types'
import React, { Component } from 'react'
import buildStateFromJSON from './buildStateFromJSON'
import Card from './Card'
import Player from './Player'
import RoundResults from './RoundResults'

export default class GameView extends Component {
    constructor(props) {
        super(props)

        let gameState = {}
        if (props.game.go_fish) gameState = buildStateFromJSON(props)
        console.log(props)

        this.state = {
            ...gameState,
            started: props.game.go_fish ? true : false,
            waitingCount: props.game.waiting_count,
            rank: ''
        }
    }

    static propTypes = {
        game:  PropTypes.object.isRequired,
        user:  PropTypes.object.isRequired,
    }

    onAsk({ id }) {
        console.log("Player selected: ", id, this.state.rank)
    }

    setRank({ rank }) {
        this.setState({rank})
    }

    render() {
        const { started, game, waitingCount, player, rank } = this.state
        return (
            <div>
                <h2>Go Fish</h2>
                {(started) ?  (
                        <div>
                            <div>{game.name}</div>
                            <div className='app-top'>
                                <div className='app--section'>
                                    <h4>Players</h4>
                                    {game.players.map((player) => (
                                        <div key={player.id}>
                                            <Player
                                                player={player}
                                                cardSelected={rank !== ''}
                                                onAsk={({id}) => this.onAsk({id})}
                                            />
                                        </div>
                                    ))}
                                </div>
                                <div>
                                    <RoundResults roundResults={game.roundResults} />
                                </div>
                            </div>
                            <div className='app--section'>
                                <h4>Hand</h4>
                                <div className='cards'>
                                    {player.hand.map((card, index) => (
                                        <Card key={index} card={card} setRank={({rank}) => this.setRank({rank})} rank={rank}/>
                                    ))}
                                </div>
                            </div>
                        </div>
                ) : (
                     <div>Waiting on {waitingCount} player{waitingCount === 1 || 's'}...</div>
                )}
            </div>
        )
    }
}
