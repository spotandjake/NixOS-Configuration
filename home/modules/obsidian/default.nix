{ lib
, config
, userConfig
, pkgs
, ...
}:

with lib;
# TODO: Any setup
let
  cfg = config.module.obsidian;
in {
  options = {
    module.obsidian.enable = mkEnableOption "Enables obsidian";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}