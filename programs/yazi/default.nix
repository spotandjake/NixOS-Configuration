{ config, lib, ... }:
with lib;
let
  name = "yazi";
  cfg = config.program."${name}";
in
{
  options.program.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      # This is off because it causes an issue in our env.nu
      enableNushellIntegration = false;
    };
  };
}
