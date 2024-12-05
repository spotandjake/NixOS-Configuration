# This script generates the required nix expressions from the config settings.
{ self, inputs, lib }:
  let
    utils = import ./utils.nix;
    # Resource Paths
    homeConfiguration   = "${self}/home";
    homeModules         = "${homeConfiguration}/modules";
    commonModules       = "${self}/modules";
    # Helper function for generating a single config
    # Helper function for generating a host configuration
    mkHost = { config, systemConfig}:
      let
        user = config.users.${systemConfig.username};
        userConfig = {
          inherit (systemConfig) username;
          inherit (systemConfig) platform;
          inherit (systemConfig) stateVersion;
          inherit (user) homebrew;
          configurations =
            user.${utils.getPlatform systemConfig.platform} ++
            user.shared;
        };
        modules = [
          {
            module.nix-config.enable = true;
            module.darwin.enable = utils.isPlatform systemConfig.platform "darwin";
          }
          "${self}/overlays/nixpkgs"
          "${commonModules}"
          "${homeConfiguration}"
        ];
        specialArgs = {
          inherit 
            inputs
            self
            systemConfig
            userConfig
            homeModules
            commonModules;
        };
      in
        # Collect Modules
        if utils.isPlatform systemConfig.platform "darwin" then
          inputs.darwin.lib.darwinSystem {
            inherit specialArgs;
            modules = [ inputs.home-manager.darwinModules.home-manager ] ++ modules;
          }
        else
          lib.nixosSystem {
            inherit specialArgs;
            modules = [ inputs.home-manager.nixosModules.home-manager ] ++ modules;
          };
  in {
    # Setup the flakes passed for each system
    forAllSystems = lib.systems.flakeExposed;
    # Generate all hosts for a given platform
    mkHosts = { config, platform }:
      # Filter out the systems to only include the current system
      let
        platformSystems = lib.filterAttrs
            (_: s: utils.isPlatform s.platform platform)
            config.systems;
      in 
        builtins.mapAttrs (_key: systemConfig: mkHost { inherit config systemConfig; }) platformSystems;
  }