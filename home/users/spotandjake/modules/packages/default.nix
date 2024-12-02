{ config
, lib
, pkgs
, inputs
, isWorkstation
, ...
}:

with lib;

let
  inherit (pkgs.stdenv) isLinux;
  cfg = config.module.user.packages;
in {
  options.module.user.packages = {
    enable = mkEnableOption "Enable user packages";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      # Utils
      bat
      tokei
      shellcheck
      pre-commit
      deadnix
      statix
      ffmpeg
      inputs.any-nix-shell

      # Security
      age
      sops
    ] ++ lib.optionals isWorkstation [
      # Chats
      discord
      whatsapp

      # Text Editors
      obsidian

      # Programming
      go
      python3
      # TODO: Add the rest of my programming stuff...

      # DevOps Utils

    ];
  };
}

