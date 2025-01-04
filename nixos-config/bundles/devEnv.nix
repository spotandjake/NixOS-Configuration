# This file is generated automatically by the `system-config` package.
{ config, lib, isDarwin,  ... }:
with lib;
let
  name = "devEnv";
  cfg = config.bundle."${name}";
in {
  options.bundle.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    program = {
      # Darwin Programs
      zsh = mkIf isDarwin {
        enable = true;
      };
      
      # Nix Programs
      
      # Shared Programs
      vscode = {
        enable = true;
      };
      gitkraken = {
        enable = true;
      };
      yazi = {
        enable = true;
      };
      fnm = {
        enable = true;
      };
      
    };
  };
}