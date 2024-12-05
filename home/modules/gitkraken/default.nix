{ config
, pkgs
, mkProgram
, ...
}: mkProgram {
  inherit config;
  # TODO: Add Configuration Files
  name = "gitkraken";
  options = {};
  setup = {
    home.packages = [ pkgs.gitkraken ];
  };
}