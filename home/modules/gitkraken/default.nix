{ lib
, config
, pkgs
, ...
}:

with lib;
let
  cfg = config.module.gitkraken;
in {
  options = {
    module.gitkraken.enable = mkEnableOption "Enables gitkraken";
  };

  config = mkIf cfg.enable {
    # TODO: Figure out if there are any settings I need to copy
    home.packages = with pkgs; [
      gitkraken
    ];
  };
}