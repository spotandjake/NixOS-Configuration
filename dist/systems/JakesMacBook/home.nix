{ inputs, self, lib, pkgs, ...}: 
{
  # TODO: Configure homeDirectory
  users.users.spotandjake = {
    name = "spotandjake";
    home = "/Users/spotandjake";
  };
  home-manager = {
    # https://home-manager-options.extranix.com/
    useGlobalPkgs   = true;
    useUserPackages = true;
    backupFileExtension = "backup-" + lib.readFile "${pkgs.runCommand "timestamp" {} "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

    users.spotandjake = {
            module.program.direnv.enable = true;
            module.program.git.enable = true;
            module.program.nushell.enable = true;
            module.program.vscode.enable = true;
            module.program.gitkraken.enable = true;
            module.program.yazi.enable = true;
            module.program.raycast.enable = true;
            module.program.iterm2.enable = true;
            module.program.arc-browser.enable = true;
            module.program.discord.enable = true;
            module.program.spotify.enable = true;
            module.program.obsidian.enable = true;
            imports = [ ../../programs ];
      home = {
        username = "spotandjake";
        homeDirectory = "/Users/spotandjake";
        # Home Manager Version
        stateVersion = "25.05";
      };
    };
  };
}