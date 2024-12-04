{ lib
, config
, pkgs
, ...
}:

with lib;
let
  cfg = config.module.iterm2;
in {
  # TODO: Configurations
  options = {
    module.iterm2.enable = mkEnableOption "Enables iterm2";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      iterm2
    ];
  };
}