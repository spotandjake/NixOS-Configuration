{
  description = "Spotandjake System Configurations";
  # Dependencies
  inputs = {
    # Current nixpkgs version
    nixpkgs.follows = "unstable";
    # Nix Packages
    master.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    # Flake Parts
    flakelight.url = "github:nix-community/flakelight?rev=621ef8ddbcc86a21fb133f6460f2a3be4afad8c6";
    # System Configurations
    darwin.url = "github:nix-darwin/nix-darwin?rev=7220b01d679e93ede8d7b25d6f392855b81dd475";
    # Home Configuration
    home-manager = {
      url = "github:nix-community/home-manager?url=d2ffdedfc39c591367b1ddf22b4ce107f029dcc3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # Config
  outputs = inputs@{ flakelight, self, ... }:
    flakelight ./. {
      # Supported Systems
      systems = [ "aarch64-darwin" ];
      # Setup darwin output
      perSystem = pkgs: {
        packages = {
          darwinConfigurations = {
            # Users
            JakesMacBook = import ./systems/JakesMacBook.nix { inherit inputs self pkgs; };
          };
        };
      };
      # Templates
      templates = import ./templates/default.nix { inherit self; };
      # Setup our devshell
      devShell.packages = pkgs: [ pkgs.treefmt pkgs.go-task ];
    };
}
