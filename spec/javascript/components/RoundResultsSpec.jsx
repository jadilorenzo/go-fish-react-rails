import React from "react";
import { render, screen } from "@testing-library/react";
import RoundResults from "components/RoundResults";

test("has all round results", () => {
    render(
        <RoundResults
            roundResults={[
                'yo mama is fat',
                'yo dad is small'
            ]}
        />
    );
    expect(screen.getByText(/yo mama/i)).toBeInTheDocument();
    expect(screen.getByText(/is fat/i)).toBeInTheDocument();
    expect(screen.getByText(/yo dad/i)).toBeInTheDocument();
    expect(screen.getByText(/is small/i)).toBeInTheDocument();
});
