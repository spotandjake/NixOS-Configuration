{
  description = "Spotandjake Flake";

  inputs = {
    # Official NixOS repo
    master = {
      url = "github:NixOS/nixpkgs/master";
    };

    unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Latest stable
    stable = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };

    # Current nixpkgs branch
    nixpkgs = {
      follows = "unstable";
    };

    # NixOS community
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:/nix-community/impermanence";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };

    nur = {
      url = "github:nix-community/NUR";
    };

    # MacOS configuration
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unofficial users flakes

    # Security
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Nushell configuration
  };

  outputs = { self, flake-parts, ... } @ inputs:
  let
    # Description of hosts
    hosts = import ./hosts.nix; 

    # Import helper functions
    libx = import ./lib { inherit self inputs; };
  in flake-parts.lib.mkFlake { inherit inputs; } {
    systems = libx.forAllSystems;

    imports = [
      ./parts
      # ./docs
    ];

    flake = {
      # NixOS Hosts configuration
      nixosConfigurations = libx.genNixos hosts.nixos;

      # MacOS Hosts configuration
      darwinConfigurations = libx.genDarwin hosts.darwin;

      # Templates
      templates = import "${self}/templates" { inherit self; };
    };
  };
}

