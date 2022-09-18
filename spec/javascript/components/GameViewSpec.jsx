import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import Game from 'components/Game'

describe('Game', () => {
    it('renders ask button when card selected', () => {
        render(<Game game={{
                id: 27,
                currentUser: {
                    name: 'Jacob',
                    hand: [
                        {'rank':'6','suit':'H'},
                        {'rank':'7','suit':'C'},
                        {'rank':'9','suit':'D'},
                        {'rank':'9','suit':'S'},
                        {'rank':'10','suit':'S'},
                        {'rank':'Queen','suit':'C'},
                        {'rank':'Ace','suit':'S'}
                    ],
                    books: [],
                    id: 3
                },
                opponents: [
                    {
                        name: 'Loretta Cronin',
                        id: -1,
                        books: [],
                        handCount: 7
                    }
                ],
                roundResults: [],
                startedStatus: true,
                waitingCount: 0,
                name: 'The Waterlogged Titanic',
                turnId: 3,
                turnName: 'Jacob'
        }}/>)
        fireEvent.click(screen.getByAltText('H_6'))
        expect(screen.getByRole(/ask--1/i)).toBeInTheDocument()
    })
})
