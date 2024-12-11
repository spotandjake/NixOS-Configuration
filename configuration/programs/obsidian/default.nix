let
  name = "obsidian";
in
{ config, pkgs,  lib, ... }: {
  options = {
    module.program.${name}.enable = lib.mkEnableOption "Enables ${name}";
  };
  config = lib.mkIf config.module.program.${name}.enable {
    home.packages = [ pkgs.obsidian ];
  };
}