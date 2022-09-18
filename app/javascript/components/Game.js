import PropTypes from 'prop-types'
import React, { Component } from 'react'
import Card from './Card'
import Player from './Player'
import RoundResults from './RoundResults'
import Api from './Api'
import Pusher from 'pusher-js'

export default class Game extends Component {
    constructor(props) {
        super(props)
        this.state = { ...props.game, rank: '' }

        console.log(props)

        if (props.game) this.connectToPusher(props)
    }

    static propTypes = {
        game:  PropTypes.object.isRequired,
    }

    connectToPusher(props) {
        const pusher = new Pusher('0bb24337fdbe74754352', { cluster: 'us2' })
        const channel = pusher.subscribe(`game-${props.game?.id}`);
        channel.bind(`update-${props.game.currentUser?.id}`, (data) => this.getGame(props))
        channel.bind(`joined`, (data) => this.getGame(props))
        channel.bind(`over`, (data) => { window.location.pathname = `/over/${props.game?.id}` })
    }

    getGame(props) {
        Api.getGame({ id: props.game?.id, userId: props.game.currentUser?.id }).then((data) => {
            this.setState({...data})
        })
    }

    async onAsk({ id }) {
        const result = await Api.playRound({
            id: this.state.id,
            asker: this.state.currentUser.id,
            askee: id,
            rank: this.state.rank,
        })
        this.setState({...result})
    }

    setRank({ rank }) {
        this.setState({ rank    })
    }

    render() {
        const {
            startedStatus,
            waitingCount,
            name,
            opponents,
            turnId,
            currentUser,
            rank,
            turnName,
            roundResults,
        } = this.state

        const isYourTurn = turnId === currentUser?.id

        return (
            <div>
                <h2>Go Fish</h2>
                {(startedStatus) ?  (
                        <div>
                            <i>{name}</i>
                            <div className='app-top'>
                                <div className='app--section'>
                                    <h4>Players</h4>
                                     <Player
                                        player={currentUser}
                                        isCurrentPlayer={isYourTurn}
                                        you
                                    />
                                    {opponents.map((player) => (
                                        <Player
                                            key={player.id}
                                            player={player}
                                            cardSelected={rank !== ''}
                                            isCurrentPlayer={turnId === player.id}
                                            isYourTurn={isYourTurn}
                                            onAsk={({id}) => this.onAsk({id})}
                                        />
                                    ))}
                                </div>
                                <div>
                                    <RoundResults roundResults={roundResults} />
                                    <br/>
                                    <u>It's {isYourTurn ? "your" : `${turnName}'s`} turn.</u>
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
