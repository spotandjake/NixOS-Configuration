let
  name = "direnv";
in
{ config, lib, ... }: {
  options = {
    module.program.${name}.enable = lib.mkEnableOption "Enables ${name}";
  };
  config = lib.mkIf config.module.program.${name}.enable {
     programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}