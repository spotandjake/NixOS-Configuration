{ config, pkgs, lib, ... }:
with lib;
let
  name = "discord";
  cfg = config.program."${name}";
in {
  options.program.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    home.packages = [
      # (pkgs.discord.override {
      #   # withOpenASAR = true; # can do this here too
      #   withVencord = true;
      # })
      pkgs.discord
    ];
  };
}