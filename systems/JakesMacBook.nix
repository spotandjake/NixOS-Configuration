{ inputs, self, pkgs }:
  let
    username = "spotandjake";
    homeDirectory = "/Users/${username}";
  in inputs.darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs self;
      hostPlatform = "aarch64-darwin";
    };
    modules = [
      # Load Dependencies
      inputs.home-manager.darwinModules.home-manager
      # Load Configurations
      {
        security.pam.services.sudo_local.touchIdAuth = true; # Allow Finger Print Reader For Sudo
        system = {
          stateVersion = 5;
          primaryUser = username;
          configurationRevision = inputs.rev or inputs.dirtyRev or null;

          defaults = {
            dock = {
              appswitcher-all-displays = null;
              autohide = false;
              autohide-delay = 99999999999999.1;
              autohide-time-modifier = null;
              dashboard-in-overlay = null;
              enable-spring-load-actions-on-all-items = null;
              expose-animation-duration = null;
              largesize = 70;
              launchanim = null;
              magnification = true;
              mineffect = null;
              minimize-to-application = null;
              mouse-over-hilite-stack = null;
              mru-spaces = null;
              orientation = null;
              persistent-apps = null;
              persistent-others = null;
              scroll-to-open = null;
              show-process-indicators = null;
              show-recents = null;
              showhidden = null;
              slow-motion-allowed = null;
              static-only = null;
              tilesize = null;
              wvous-bl-corner = null;
              wvous-br-corner = null;
              wvous-tl-corner = null;
              wvous-tr-corner = null;
            };
            CustomUserPreferences = {
              LaunchServices.LSQuarantine = false;
              NSGlobalDomain.AppleShowAllExtensions = true;
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
          };
          # Updates the mac system without login/logout
          # activationScripts.postUserActivation.text = ''
          #   # Following line should allow us to avoid a logout/login cycle
          #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
          # '';
        };
        homebrew = {
          # This is a module from nix-darwin
          # Homebrew is *installed* via the flake input nix-homebrew
          enable = true;
          casks = [ "lunar" "1Password" "1password-cli" "ghostty" ];
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
        users.users."${username}" = {
          name = "${username}";
          home = homeDirectory;
        };
        home-manager = {
          extraSpecialArgs = { inherit inputs; };
          # https://home-manager-options.extranix.com/
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup-" + builtins.readFile "${pkgs.runCommand "timestamp" {} "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

          users."${username}" = {
            # Darwin Programs
            program.spicetify.enable = true;
            # Nix Programs
            # Shared Programs
            # Bundles
            bundle.minimalDevShell.enable = true;
            bundle.devEnv.enable = true;
            bundle.workStation.enable = true;
            imports = [
              ../bundles
              ../programs
            ];
            home = {
              username = username;
              inherit homeDirectory;
              # Home Manager Version
              stateVersion = "25.11";
            };
          };
        };
      }
      # Load Scaffold Pieces
      ../overlays
      ../modules
    ];
  }