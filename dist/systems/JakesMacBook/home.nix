{ config, inputs, self, lib, pkgs, ...}: {
  # TODO: Configure homeDirectory
  users.users.eve = {
    name = "spotandjake";
    home = "/Users/spotandjake";
  };
  home-manager = {
    # https://home-manager-options.extranix.com/
    useGlobalPkgs   = true;
    useUserPackages = true;
    backupFileExtension = "backup-" + lib.readFile "${pkgs.runCommand "timestamp" {} "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

    extraSpecialArgs  = {
      inherit inputs self;
    };

    users.spotandjake = {
      # imports = userConfig.configurations ++ [ "${homeModules}" ];
      home = {
        username = "spotandjake";
        homeDirectory = "/Users/spotandjake";
        # Home Manager Version
        stateVersion = "25.05";
      };
    };
  };
}