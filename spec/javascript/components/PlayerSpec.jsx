import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import Player from "components/Player";


test("renders player", () => {
    render(<Player
        player={{
            name: 'Yo Mama',
            handCount: 3,
            id: 0,
            books: []
        }}
        isCurrentPlayer={false}
        you
    />);
    expect(screen.queryByText(/yo mama/i)).toBeInTheDocument();
    expect(screen.queryByText(/(you)/i)).toBeInTheDocument();
    expect(screen.queryByText(/ask/i)).not.toBeInTheDocument();
});

test("renders bot with ask button", () => {
    const onAsk = jest.fn()
    render(<Player
        onAsk={onAsk}
        player={{
            name: 'Boe Jiden',
            handCount: 3,
            id: 1,
            books: []
        }}
        isCurrentPlayer={true}
        isYourTurn
        cardSelected
    />);
    expect(screen.queryByText(/boe jiden/i)).toBeInTheDocument();
    expect(screen.queryByText(/(you)/i)).not.toBeInTheDocument();
    expect(screen.getByRole(/ask-1/i)).toBeInTheDocument();
});

test("calls back with index", () => {
    const onAsk = jest.fn()
    render(<Player
        onAsk={onAsk}
        player={{
            name: 'Boe Jiden',
            handCount: 3,
            id: 1,
            books: []
        }}
        isCurrentPlayer={true}
        isYourTurn
        cardSelected
    />);
    fireEvent.click(screen.getByRole(/ask-1/i))
    expect(onAsk).toHaveBeenCalledWith({id: 1});
});
