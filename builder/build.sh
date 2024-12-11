# !bin/bash

deno run start
cd ../dist
nix flake check --show-trace