{ config, lib, ... }:
with lib;
let
  name = "direnv";
  cfg = config.program."${name}";
in
{
  options.program.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
