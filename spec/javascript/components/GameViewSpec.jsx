import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import GameView from 'components/GameView'
import test from './test.json'

describe("GameView", () => {
    it("works", () => {
        render(<GameView game={test.game} user={test.user}/>)
        expect(screen.getByText(/jacob sucks/i)).toBeTruthy()
    })

    it("renders ask button when card selected", () => {
        render(<GameView game={test.game} user={test.user} />)
        fireEvent.click(screen.getByAltText('S_4'))
        expect(screen.getByRole(/ask-1/i)).toBeInTheDocument()
    })
})
