let
  name = "nushell";
in
{ config, pkgs, lib, ... }: {
  options = {
    module.program.${name}.enable = lib.mkEnableOption "Enables ${name}";
  };
  config = lib.mkIf config.module.program.${name}.enable {
    programs.nushell = {
      enable = true;
      # TODO: Enable configs
      # configFile.source = ./nushell/config.nu;
      # envFile.source = ./nushell/env.nu;
    };
  };
}