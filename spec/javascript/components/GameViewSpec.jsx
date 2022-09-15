import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import GameView from 'components/GameView'

describe("GameView", () => {
    it("works", () => {
        render(<GameView game={''} user={''}/>)
        expect(screen.queryByText('blah')).not.toBeTruthy()
    })
})
