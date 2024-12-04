{
  description = "Spotandjake Flake";
  # Nix Sources
  inputs = {
    # Official NixOS repo
    master.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    # Current nixpkgs branch
    nixpkgs.follows = "unstable";
    # NixOS community
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # impermanence.url = "github:/nix-community/impermanence";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # MacOS configuration
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Security
    sops-nix.url = "github:Mic92/sops-nix";
  };
  # Nix Script
  outputs = { self, flake-parts, nixpkgs, ... } @ inputs:
    let
      config = import ./config.nix { inherit inputs; lib = nixpkgs.lib; };
      # Import The Generator library
      gen = import ./lib { inherit self inputs; };
    in flake-parts.lib.mkFlake { inherit inputs; } {
      # Generate The Parts
      systems = gen.forAllSystems;
      # Load Nix Parts Scripts
      imports = [./parts];
      # Generate The Hosts
      flake = {
        # Operating System Configurations
        nixosConfigurations = gen.mkHost {
          inherit config;
          system = "nixos";
        };
        darwinConfigurations = gen.mkHost {
          inherit config;
          system = "darwin";
        };
        # Flake Templates
        templates = import "${self}/templates" { inherit self; };
      };
    };
}