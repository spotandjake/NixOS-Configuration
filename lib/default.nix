# This script generates the required nix expressions from the config settings.
{ self, inputs }:
  let
    # Resource Paths
    homeConfiguration   = "${self}/home";
    systemConfiguration = "${self}/system";

    homeModules         = "${homeConfiguration}/modules";
    commonModules       = "${self}/modules";
    # Helper function for generating a single config
    mkConfig = { config, systemConfig }:
      let
        userConfig = config.users.${systemConfig.username};
        system = systemConfig.system;
        configList = userConfig.${system} ++ userConfig.shared;
      in
        {
          username = systemConfig.username;
          platform = systemConfig.platform;
          system = system;
          stateVersion = systemConfig.stateVersion;
          configuration = (inputs.nixpkgs.lib.lists.foldl
              (acc: value: inputs.nixpkgs.lib.recursiveUpdate acc value)
              {}
              configList
            );
        };
    # Helper function for generating a host configuration
    mkHostHelp = { config, systemConfig}:
      let
        userConfig = mkConfig { inherit config systemConfig; };
        modules = [
          {
            module.nix-config.enable = true;
            programs.zsh.enable = true;
            security.pam.enableSudoTouchIdAuth = true; # Enable fingerprint sudo
            system.stateVersion = systemConfig.stateVersion;
            system.activationScripts.postUserActivation.text = ''
              # Following line should allow us to avoid a logout/login cycle
              /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
            '';
            nix.extraOptions = inputs.nixpkgs.lib.optionalString (systemConfig.platform == "aarch64-darwin") ''
              extra-platforms = x86_64-darwin aarch64-darwin
            '';
            nix.linux-builder.enable = true;
          }
          "${commonModules}"
          "${homeConfiguration}"
        ];
        specialArgs = {
          # TODO: Look into requirements for this???
          inherit 
            inputs
            self
            userConfig
            homeModules
            commonModules;
        };
      in
        # Collect Modules
        if systemConfig.system == "darwin" then
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
        currentSystems = (inputs.nixpkgs.lib.filterAttrs (_: s: s.system == system) config.systems);
      in 
        builtins.mapAttrs (key: systemConfig: mkHostHelp { inherit config systemConfig; }) currentSystems;
  in {
    # Setup the flakes passed for each system
    forAllSystems = inputs.nixpkgs.lib.systems.flakeExposed;

    # This is just a function that takes the config and the system and generates all hosts for the system
    mkHost = mkHost;
  }