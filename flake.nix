{
  # Read: https://tonyfinn.com/blog/nix-from-first-principles-flake-edition/nix-5-derivation-intro/
  # Read: https://discourse.nixos.org/t/using-a-custom-derivation-in-nixos-flake/42632
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { systems, nixpkgs, ... }@inputs:
    let
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          buildInputs = [ pkgs.deno ];
        };
      });
    };
}
