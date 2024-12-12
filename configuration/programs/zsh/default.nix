{ config, lib, ... }:
with lib;
let
  name = "zsh";
  cfg = config.program."${name}";
in {
  options.program.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    home.file.".zshrc".source = ./.zshrc;
    programs.zsh = {
      enable = true;
      # TODO: Configuration
    };
  };
}