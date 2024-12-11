let
  name = "yazi";
in
{ config, pkgs,  lib, ... }: {
  options = {
    module.program.${name}.enable = lib.mkEnableOption "Enables ${name}";
  };
  config = lib.mkIf config.module.program.${name}.enable {
    programs.yazi = {
      enable = true;
      # This is off because it causes an issue in our env.nu
      enableNushellIntegration = false;
    };
  };
}