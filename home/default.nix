{ self
, pkgs
, lib
, inputs
, userConfig
, homeModules
, commonModules
, ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;
  
  username = userConfig.username;
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
in {
  users.users.${username}.home = homeDirectory;
  home-manager = {
    useGlobalPkgs   = true;
    useUserPackages = true;
    backupFileExtension = "backup-" + pkgs.lib.readFile "${pkgs.runCommand "timestamp" {} "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

    extraSpecialArgs  = {
      inherit 
        inputs 
        self 
        userConfig 
        isLinux
        isDarwin
        commonModules 
        homeModules;
    };

    users.${username} = {
      imports = [
        # Map our configurations to the home-manager module configurations
        (lib.foldlAttrs (acc: name: value: lib.recursiveUpdate acc {
          module.${name}.enable = value;
        }) {} userConfig.configuration.programs)
        # inputs.impermanence.nixosModules.home-manager.impermanence
        # inputs.sops-nix.homeManagerModules.sops
        # inputs.nur.nixosModules.nur
        "${homeModules}"
      ];

      home = {
        inherit username homeDirectory;
        # Home Manager Version
        stateVersion = "25.05";
      };
    };
  };
}