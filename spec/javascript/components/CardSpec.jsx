import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import Card from "components/Card";

test("calls setRank", () => {
    const setRank = jest.fn()
    render(<Card rank={''} card={{ suit: 'C', rank: 'Ace' }} setRank={({rank}) => setRank({rank})} />);
    const card = screen.getByAltText(/C_A/i)
    expect(card).toBeInTheDocument();
    fireEvent.click(card)
    expect(setRank).toBeCalledWith({ rank: 'Ace' })
});
