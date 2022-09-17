import PropTypes from 'prop-types'
import React, { Component } from 'react'
import Card from './Card'
import Player from './Player'
import RoundResults from './RoundResults'

export default class Game extends Component {
    constructor(props) {
        super(props)

        this.state = {
            ...props.game,
            rank: ''
        }
    }

    static propTypes = {
        game:  PropTypes.object.isRequired,
    }

    onAsk({ id }) {
        console.log("Player selected: ", id, this.state.rank)
    }

    setRank({ rank }) {
        this.setState({rank})
    }

    render() {
        const {
            started,
            waitingCount,
            name,
            opponents,
            turnId,
            currentUser,
            rank,
            turnName,
            roundResults,
        } = this.state

        const isYourTurn = turnId === currentUser.id

        console.log(this.state, rank)

        return (
            <div>
                <h2>Go Fish</h2>
                {(!started) ?  (
                        <div>
                            <div>{name}</div>
                            <div className='app-top'>
                                <div className='app--section'>
                                    <h4>Players</h4>
                                     <Player
                                        player={currentUser}
                                        you
                                    />
                                    {opponents.map((player) => (
                                        <Player
                                            key={player.id}
                                            player={player}
                                            cardSelected={rank !== ''}
                                            isYourTurn={isYourTurn}
                                            onAsk={({id}) => this.onAsk({id})}
                                        />
                                    ))}
                                </div>
                                <div>
                                    <RoundResults roundResults={roundResults} />
                                    <br/>
                                    <u>It's {turnName}'s turn.</u>
                                </div>
                            </div>
                            <div className='app--section'>
                                <h4>Hand</h4>
                                <div className='cards'>
                                    {currentUser.hand.map((card, index) => (
                                        <Card
                                            key={index}
                                            card={card}
                                            setRank={({rank}) => this.setRank({rank})}
                                            rank={rank}
                                        />
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
