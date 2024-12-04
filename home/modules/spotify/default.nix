{ lib
, config
, userConfig
, pkgs
, ...
}:

with lib;
# TODO: Authentication
let
  cfg = config.module.spotify;
in {
  options = {
    module.spotify.enable = mkEnableOption "Enables spotify";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
    ];
  };
}