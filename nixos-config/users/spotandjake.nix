# This file is generated automatically by the `system-config` package.
{ lib, pkgs, isDarwin, isNix, ...}: 
with lib;
let
  name = "spotandjake";
  homeDirectory = if isNix then "/home/${name}" else "/Users/${name}";
in
{
  # TODO: Dock settings and stuff like that
  users.users."${name}" = {
    name = "${name}";
    home = homeDirectory;
  };
  home-manager = {
    extraSpecialArgs = { inherit isDarwin is Nix; };
    # https://home-manager-options.extranix.com/
    useGlobalPkgs   = true;
    useUserPackages = true;
    backupFileExtension = "backup-" + readFile "${pkgs.runCommand "timestamp" {} "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

    users."${name}" = {
      # Darwin Programs
      
      # Nix Programs
      
      # Shared Programs
      
      # Bundles
      bundle.minimalDevShell.enable = true;
      bundle.devEnv.enable = true;
      bundle.workStation.enable = true;
    
      imports = [ ../bundles ../programs ];
      home = {
        username = name;
        inherit homeDirectory;
        # Home Manager Version
        stateVersion = "25.05";
      };
    };
  };
}