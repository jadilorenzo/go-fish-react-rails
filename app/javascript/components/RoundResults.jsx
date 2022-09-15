import PropTypes from 'prop-types'
import React, { Component } from 'react'

export default class RoundResults extends Component {
    constructor(props) {
        super(props)
        this.props = props
    }

    static propTypes = {
        roundResults: PropTypes.array.isRequired
    }

    render() {
        return (
            <div>
                <div>Round Results:</div>
                {this.props.roundResults.map((result, index) => <div key={index}>{result}</div>)}
            </div>
        )
    }
}
