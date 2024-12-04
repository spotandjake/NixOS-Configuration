{ config
, pkgs
, loader
, ...
}: loader.mkProgram {
  inherit config;
  # TODO: Add Configuration Files
  name = "arc-browser";
  options = {};
  setup = {
    home.packages = [ pkgs.arc-browser ];
  };
}