import PropTypes from 'prop-types'
import React, { Component } from 'react'

export default class GameView extends Component {
    constructor(props) {
        super(props)
        this.props = props
        console.log(props)
    }

    static propTypes = {
        game:  PropTypes.object.isRequired,
        user:  PropTypes.object.isRequired
    }

    render() {
        return (
            <div>{this.props.game.name}</div>
        )
    }
}
