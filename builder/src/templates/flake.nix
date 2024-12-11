{
  description = "Spotandjake System Configurations";

  inputs = {
    # Current nixpkgs version
    nixpkgs.follows = "unstable";
    # Nix Packages
    master.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    # Flake Parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # System Configurations
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets
    opnix = {
      url = "github:mrjones2014/opnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: Impermanence
    # Home Configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Tools
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Systems This Configuration Supports
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      # Flake parts Templates
      flake = {
        # TODO: Nix
        # Nix Darwin
        darwinConfigurations = "%~ darwinConfigurations %";
        # Nix Os
        nixosConfigurations = "%~ nixosConfigurations %";
        # Templates
        templates = import "${self}/templates" { inherit self; };
      };
    };
}