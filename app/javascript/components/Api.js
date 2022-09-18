const Api = {
    playRound: async ({id, rank, askee, asker}) => {
        const data = await fetch(`/games/${id}/play_round`, {
            method: 'PATCH',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                body: {
                    asker: asker,
                    askee: askee,
                    rank: rank,
                }
            })
        }).then(data => data.json())
        return data
    },
    getGame: ({id, userId}) => {
        return fetch(`/games/${id}/state_for/${userId}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
        }).then(data => data.json())
    }
}

export default Api
