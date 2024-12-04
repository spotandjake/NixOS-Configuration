{ inputs
, lib
, config
, pkgs
, userConfig
, ...
}:

with lib;

let
  cfg = config.module.nix-config;
in {
  options = {
    module.nix-config = {
      enable = mkEnableOption "Enables nix-config";

      useNixPackageManagerConfig = mkOption {
        type = types.bool;
        description = "Whether to use custom Nix package manager settings.";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.hostPlatform = userConfig.platform;
    # Nixpkgs config
    nixpkgs.config = {
      allowUnfree = true;

      permittedInsecurePackages = [];
    };

    # Nix package manager settings
    nix = {
      package = pkgs.nixVersions.latest;
      registry.s.flake = inputs.self;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];

        substituters = [];

        trusted-public-keys = [];
      };

      optimise = {
        automatic = true;
      };

      gc = {
        automatic = true;
        options = "--delete-older-than 14d";
      };
    };
  };
}
