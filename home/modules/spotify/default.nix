{ config
, pkgs
, loader
, ...
}: loader.mkProgram {
  inherit config;
  name = "spotify";
  options = {};
  setup = {
    home.packages = [ pkgs.spotify ];
  };
}