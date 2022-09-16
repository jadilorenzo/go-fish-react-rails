import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import Card from "components/Card";
import { CardModel } from "models";

test("calls setRank", () => {
    const setRank = jest.fn()
    render(<Card card={new CardModel({ suit: 'C', rank: 'A' })} setRank={({rank}) => setRank({rank})} />);
    const card = screen.getByAltText(/C_A/i)
    expect(card).toBeInTheDocument();
    fireEvent.click(card)
    expect(setRank).toBeCalledWith({ rank: 'A' })
});
