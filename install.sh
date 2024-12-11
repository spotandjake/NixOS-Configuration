cd builder
direnv allow
bash build.sh
cd ..
cd dist
nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake . --show-trace