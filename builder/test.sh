# !bin/bash

deno run start
cd ../dist
nix flake check --show-trace
nix run nix-darwin -- switch --flake . --show-trace