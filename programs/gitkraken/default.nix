{ config, pkgs, lib, ... }:
with lib;
let
  name = "gitkraken";
  cfg = config.program."${name}";
in
{
  options.program.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.gitkraken ];
  };
}
