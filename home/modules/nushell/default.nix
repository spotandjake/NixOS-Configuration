{ lib
, config
, homeModules
, ...
}:

with lib;
let
  cfg = config.module.nushell;
in {
  options = {
    module.nushell.enable = mkEnableOption "Enables nushell";
  };

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      configFile.source = "${homeModules}/nushell/config.nu";
      envFile.source = "${homeModules}/nushell/env.nu";
    };
  };
}