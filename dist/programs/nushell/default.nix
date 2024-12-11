let
  name = "nushell";
in
{ config, lib, ... }: {
  options = {
    module.program.${name}.enable = lib.mkEnableOption "Enables ${name}";
  };
  config = lib.mkIf config.module.program.${name}.enable {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
    };
  };
}