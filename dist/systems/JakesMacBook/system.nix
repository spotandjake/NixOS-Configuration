{ inputs, self }: inputs.darwin.lib.darwinSystem {
  specialArgs = { inherit inputs self; hostPlatform = "aarch64-darwin"; };
  modules = [
    # Darwin Configuration
    {
      # TODO: Move this to its own config
      system = {
        stateVersion = 5;
        configurationRevision = inputs.rev or inputs.dirtyRev or null;
        # Updates the mac system without login/logout
        activationScripts.postUserActivation.text = ''
          # Following line should allow us to avoid a logout/login cycle
          /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        '';
      };
      # Enable Finger Print Reader
      security.pam.enableSudoTouchIdAuth = true;
    }
    # Load overlays
    ../../overlays
    # Modules
    ../../modules
    # TODO: Secrets
    # inputs.opnix.nixosModules.default
    # ./secrets.nix
    inputs.home-manager.darwinModules.home-manager
    ./home.nix
  ];
}