# Hook

A very simple web api for handling forwarding slskd webhooks to ntfy.

## Installation

Can be built using `mix compile`, or using nix `nix build .#`.

## Usage

Run using `nix run .# --start` or using `mix server`. Remember to set the relevant env vars especially AUTH_TOKEN, otherwise no authorization will be done.
