# !bin/bash

deno run test
git add *
cd nixos-config
nix flake check --show-trace
nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake . --show-trace