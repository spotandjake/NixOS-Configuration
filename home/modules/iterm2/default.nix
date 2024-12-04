{ config
, pkgs
, loader
, ...
}: loader.mkProgram {
  inherit config;
  # TODO: Add Configuration Files
  name = "iterm2";
  options = {};
  setup = {
    home.packages = [ pkgs.iterm2 ];
  };
}