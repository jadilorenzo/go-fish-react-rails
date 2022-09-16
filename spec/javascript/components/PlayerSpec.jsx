import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import Player from "components/Player";
import {
    BotModel,
    PlayerModel
} from "models";

test("renders player", () => {
    render(<Player onAsk={() => {}} player={new PlayerModel({
        name: 'Yo Mama',
        id: 0,
        user: { id: 0 }
    })} cardSelected={false} />);
    expect(screen.queryByText(/yo mama/i)).toBeInTheDocument();
    expect(screen.queryByText(/(you)/i)).toBeInTheDocument();
    expect(screen.queryByText(/ask/i)).not.toBeInTheDocument();
});

test("renders bot with ask button", () => {
    const onAsk = jest.fn()
    render(<Player onAsk={onAsk} player={new PlayerModel({
        name: 'Boe Jiden',
        id: 1,
        user: { id: 0 }
    })} cardSelected={true} />);
    expect(screen.queryByText(/boe jiden/i)).toBeInTheDocument();
    expect(screen.queryByText(/(you)/i)).not.toBeInTheDocument();
    expect(screen.getByRole(/ask-1/i)).toBeInTheDocument();
});

test("calls back with index", () => {
    const onAsk = jest.fn()
    render(<Player onAsk={onAsk} player={new PlayerModel({
        name: 'Boe Jiden',
        id: 1,
        user: { id: 0 }
    })} cardSelected={true} />);
    fireEvent.click(screen.getByRole(/ask-1/i))
    expect(onAsk).toHaveBeenCalledWith({id: 1});
});
