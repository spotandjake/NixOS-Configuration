# This file is generated automatically by the `system-config` package.
{ inputs, lib, pkgs, isDarwin, isNix, ...}: 
with lib;
let
  name = "spotandjake";
  homeDirectory = if isNix then "/home/${name}" else "/Users/${name}";
in
{
  system.defaults.dock = {
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
  };  # TODO: Dock settings and stuff like that
  users.users."${name}" = {
    name = "${name}";
    home = homeDirectory;
  };
  home-manager = {
    extraSpecialArgs = { inherit inputs isDarwin is Nix; };
    # https://home-manager-options.extranix.com/
    useGlobalPkgs   = true;
    useUserPackages = true;
    backupFileExtension = "backup-" + readFile "${pkgs.runCommand "timestamp" {} "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

    users."${name}" = {
      # Darwin Programs
      program.spicetify = mkIf isDarwin {
        enable = true;
      };
      program.mars = mkIf isDarwin {
        enable = true;
      };
      
      # Nix Programs
      
      # Shared Programs
      
      # Bundles
      bundle.minimalDevShell.enable = true;
      bundle.devEnv.enable = true;
      bundle.workStation.enable = true;
    
      imports = [
        ../bundles
        ../programs
        # inputs.impermanence.homeManagerModules.impermanence
      ];
      home = {
        username = name;
        inherit homeDirectory;
        # Home Manager Version
        stateVersion = "25.05";
        # Impersistance
        # persistence."/persistent/home/${name}" = {
        #   directories = [
        #     "Desktop"
        #     "Downloads"
        #     "Music"
        #     "Pictures"
        #     "Documents"
        #     "Videos"
        #   ];
        #   files = [];
        #   allowOther = true;
        # };
      };
    };
  };
}