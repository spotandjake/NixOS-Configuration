# This file is generated automatically by the `system-config` package.
{ config, lib,   ... }:
with lib;
let
  name = "minimalDevShell";
  cfg = config.bundle."${name}";
in {
  options.bundle.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    program = {
      # Darwin Programs
      
      # Nix Programs
      
      # Shared Programs
      direnv = {
        enable = true;
      };
      devenv = {
        enable = true;
      };
      git = {
        enable = true;
      };
      nushell = {
        enable = true;
      };
      
    };
  };
}