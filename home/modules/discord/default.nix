{ config
, pkgs
, loader
, ...
}: loader.mkProgram {
  inherit config;
  # TODO: Add Configuration Files
  name = "discord";
  options = {};
  setup = {
    home.packages = [ pkgs.discord ];
  };
}