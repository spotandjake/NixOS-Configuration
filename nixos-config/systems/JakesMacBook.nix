# This file is generated automatically by the `system-config` package.
{ inputs, self }:
let
  user = "spotandjake";
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
    # TODO: Allow all of this to be configured
    system.defaults.CustomUserPreferences = {
      LaunchServices = {
        LSQuarantine = false;
      };
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
      };
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        _FXShowPosixPathInTitle = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
    };
    homebrew = {
      # This is a module from nix-darwin
      # Homebrew is *installed* via the flake input nix-homebrew
      enable = true;
      casks = [ "lunar" "1Password" "1password-cli" ];

      # These app IDs are from using the mas CLI app
      # mas = mac app store
      # https://github.com/mas-cli/mas
      #
      # $ nix shell nixpkgs#mas
      # $ mas search <app name>
      #
      masApps = {
        "WhatsApp Messenger" = 310633997;
      };
    };
  };
  platform = "aarch64-darwin";
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