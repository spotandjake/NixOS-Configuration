{ lib
, config
, pkgs
, ...
}:

with lib;
# TODO: Authentication
let
  cfg = config.module.discord;
in {
  options = {
    module.discord.enable = mkEnableOption "Enables discord";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}