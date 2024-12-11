{ inputs, self, lib, pkgs, ...}: 
{
  # TODO: Configure homeDirectory
  users.users."%~ username %" = {
    name = ""%~ username %"";
    home = ""%~ homeDirectory %"";
  };
  home-manager = {
    # https://home-manager-options.extranix.com/
    useGlobalPkgs   = true;
    useUserPackages = true;
    backupFileExtension = "backup-" + lib.readFile "${pkgs.runCommand "timestamp" {} "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

    users."%~ username %" = {
      "% programs.forEach(p => { %"
      module.program."%~ p %".enable = true;
      "% }) %"
      imports = [ ../../programs ];
      home = {
        username = ""%~ username %"";
        homeDirectory = ""%~ homeDirectory %"";
        # Home Manager Version
        stateVersion = "25.05";
      };
    };
  };
}