{ config
, pkgs
, loader
, ...
}: loader.mkProgram {
  inherit config;
  # TODO: Add Configuration Files
  name = "obsidian";
  options = {};
  setup = {
    home.packages = [ pkgs.obsidian ];
  };
}