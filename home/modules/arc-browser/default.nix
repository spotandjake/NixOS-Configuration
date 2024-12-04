{ lib
, config
, pkgs
, ...
}:

with lib;
let
  cfg = config.module.arc-browser;
in {
  # TODO: Configurations
  options = {
    module.arc-browser.enable = mkEnableOption "Enables arc-browser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      arc-browser
    ];
  };
}