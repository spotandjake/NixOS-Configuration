{ config
, pkgs
, mkProgram
, ...
}: mkProgram {
  inherit config;
  # TODO: Add Configuration Files
  name = "raycast";
  options = {};
  setup = {
    home.packages = [ pkgs.raycast ];
  };
}