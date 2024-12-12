# This file is generated automatically by the `system-config` package.
{ inputs, self }:
let
  user = ""%~ user %"";
  systemConfiguration = {
    security.pam.enableSudoTouchIdAuth = true; # Allow Finger Print Reader For Sudo
    services.nix-daemon.enable = true;
    system = {
      stateVersion = 5;
      configurationRevision = inputs.rev or inputs.dirtyRev or null;
      # Updates the mac system without login/logout
      activationScripts.postUserActivation.text = ''
        # Following line should allow us to avoid a logout/login cycle
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
    };
  };
  platform = ""%~ platform %"";
in
inputs.darwin.lib.darwinSystem {
  specialArgs = {
    inherit inputs self;
    hostPlatform = platform;
    isDarwin = true;
    isNix = false;
  };
  modules = [
    # Load Dependencies
    # TODO: inputs.opnix.nixosModules.default
    inputs.home-manager.darwinModules.home-manager
    # Load System Configuration
    systemConfiguration
    # Load User
    ../users/${user}.nix
    # Load Scaffold Pieces
    ../overlays
    ../modules
  ];
}