# This script generates the required nix expressions from the config settings.
{ self, inputs }:
  let
    utils = import ./utils.nix;
    # Resource Paths
    homeConfiguration   = "${self}/home";
    homeModules         = "${homeConfiguration}/modules";
    commonModules       = "${self}/modules";
    # Helper function for generating a single config
    mkConfig = { config, systemConfig }:
      let
        userConfig = config.users.${systemConfig.username};
      in
        {
          inherit (systemConfig) username;
          inherit (systemConfig) platform;
          inherit (systemConfig) stateVersion;
          configurations = userConfig.${utils.getPlatform systemConfig.platform} ++ userConfig.shared;
        };
    # Helper function for generating a host configuration
    mkHostHelp = { config, systemConfig}:
      let
        userConfig = mkConfig { inherit config systemConfig; };
        modules = [
          {
            module.nix-config.enable = true;
            module.darwin.enable = utils.isPlatform systemConfig.platform "darwin";
          }
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
          inputs.nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            modules = [ inputs.home-manager.nixosModules.home-manager ] ++ modules;
          };
    # Helper function for generating darwin host configs
    mkHost = { config, system }:
      # Filter out the systems to only include the current system
      let
        currentSystems = inputs.nixpkgs.lib.filterAttrs (_: s: utils.isPlatform s.platform system) config.systems;
      in 
        builtins.mapAttrs (_key: systemConfig: mkHostHelp { inherit config systemConfig; }) currentSystems;
  in {
    # Setup the flakes passed for each system
    forAllSystems = inputs.nixpkgs.lib.systems.flakeExposed;

    # This is just a function that takes the config and the system and generates all hosts for the system
    inherit mkHost;
  }