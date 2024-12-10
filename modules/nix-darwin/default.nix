{ inputs, self, withSystem, ... }:
let
  users = import "${self}/users.nix";
  systems = import "${self}/systems.nix" { inherit users; };
in {
  # This should be per user
  # TODO: Exopse the package set
  config.flake.darwinConfigurations = 
    (builtins.listToAttrs
      (builtins.map
        (sysConfig: 
          (withSystem
            sysConfig.specs.platform
            (ctx: {
              name = sysConfig.name;
              value = inputs.darwin.lib.darwinSystem {
                system = {
                  configurationRevision = self.rev or self.dirtyRev or null;
                  stateVersion = 5;
                };
                # TODO: Home Manager
                # TODO: opsNix
                # TODO: Darwin Configurations
                modules = [
                  inputs.home-manager.darwinModules.home-manager
                ];
              };
            })
          )
        )
        (builtins.filter
          (s: s.specs.platform == "aarch64-darwin" || s.specs.platform == "x86_64-darwin")
          systems
        )
      )
    );
}