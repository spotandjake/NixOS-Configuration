# This file is generated automatically by the `system-config` package.
{ inputs, lib, pkgs, isDarwin, isNix, ...}: 
with lib;
let
  name = ""%~ name %"";
  homeDirectory = if isNix then "/home/${name}" else "/Users/${name}";
in
{
  "%~ (darwin.dock != null) ? `system.defaults.dock = ${objToNix(darwin.dock)}` : '' %"
  # TODO: Dock settings and stuff like that
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
      "% darwin.programs.forEach((program) => { %"
program."%~ program.name %" = mkIf isDarwin {
        enable = "%~ program.enable %";
      };
      "% }); %"

      # Nix Programs
      "% nix.programs.forEach((program) => { %"
program."%~ program.name %" = mkIf isNix {
        enable = "%~ program.enable %";
      };
      "% }); %"

      # Shared Programs
      "% shared.programs.forEach((program) => { %"
program."%~ program.name %" = {
        enable = "%~ program.enable %";
      };
      "% }); %"

      # Bundles
    "% bundles.forEach(bundle => { %"
  bundle."%~ bundle %".enable = true;
    "% }); %"

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