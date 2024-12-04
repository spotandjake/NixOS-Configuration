{ lib
, config
, userConfig
, ...
}:

with lib;
let
  cfg = config.module.yazi;
in {
  options = {
    module.yazi.enable = mkEnableOption "Enables yazi";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      # This is off because it causes an issue in our env.nu
      enableNushellIntegration = false;
    };
  };
}