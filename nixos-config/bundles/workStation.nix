# This file is generated automatically by the `system-config` package.
{ config, lib, isDarwin,  ... }:
with lib;
let
  name = "workStation";
  cfg = config.bundle."${name}";
in {
  options.bundle.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    program = {
      # Darwin Programs
      raycast = mkIf isDarwin {
        enable = true;
      };
      iterm2 = mkIf isDarwin {
        enable = true;
      };
      
      # Nix Programs
      
      # Shared Programs
      arc-browser = {
        enable = true;
      };
      discord = {
        enable = true;
      };
      spotify = {
        enable = true;
      };
      obsidian = {
        enable = true;
      };
      
    };
  };
}