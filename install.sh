nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake . --show-trace
# nix run cachix authtoken XXXX
# nix run cachix push spotandjakeflake