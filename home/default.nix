{ self
, pkgs
, lib
, inputs
, userConfig
, homeModules
, ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
  
  inherit (userConfig) username;
  homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
  # Custom Module System Macros
  mkProgram = {
    config,
    name,
    options ? {},
    setup
  }:
  {
    options = options // {
      module.program.${name}.enable = lib.mkEnableOption "Enables ${name}";
    };
    config = lib.mkIf config.module.program.${name}.enable setup;
  };
in {
  users.users.${username}.home = homeDirectory;
  home-manager = {
    useGlobalPkgs   = true;
    useUserPackages = true;
    backupFileExtension = "backup-" + lib.readFile "${pkgs.runCommand "timestamp" {} "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

    extraSpecialArgs  = {
      inherit 
        inputs 
        self   
        homeModules
        mkProgram;
    };

    users.${username} = {
      imports = userConfig.configurations ++ [ "${homeModules}" ];

      home = {
        inherit username homeDirectory;
        # Home Manager Version
        stateVersion = "25.05";
      };
    };
  };
}