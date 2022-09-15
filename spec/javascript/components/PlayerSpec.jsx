import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import Player from "components/Player";
import {
    BotModel,
    PlayerModel
} from "models";

test("renders player", () => {
    render(<Player onAsk={() => {}} player={new PlayerModel('Yo Mama')} index={0} cardSelected={false} />);
    expect(screen.queryByText(/yo mama/i)).toBeInTheDocument();
    expect(screen.queryByText(/(you)/i)).toBeInTheDocument();
    expect(screen.queryByText(/ask/i)).not.toBeInTheDocument();
});

test("renders bot with ask button", () => {
    const onAsk = jest.fn()
    render(<Player onAsk={onAsk} player={new BotModel("Boe Jiden")} index={1} cardSelected={true} />);
    expect(screen.queryByText(/boe jiden/i)).toBeInTheDocument();
    expect(screen.queryByText(/(you)/i)).not.toBeInTheDocument();
    expect(screen.getByRole(/ask-1/i)).toBeInTheDocument();
});
