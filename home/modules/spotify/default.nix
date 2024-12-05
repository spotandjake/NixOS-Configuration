{ config
, pkgs
, mkProgram
, ...
}: mkProgram {
  inherit config;
  name = "spotify";
  options = {};
  setup = {
    home.packages = [ pkgs.spotify ];
  };
}