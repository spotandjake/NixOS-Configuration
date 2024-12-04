{ lib
, config
, pkgs
, ...
}:

with lib;
# TODO: Look into setup
let
  cfg = config.module.raycast;
in {
  options = {
    module.raycast.enable = mkEnableOption "Enables raycast";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      raycast
    ];
  };
}