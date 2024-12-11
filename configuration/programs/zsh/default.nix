let
  name = "zsh";
in
{ config, pkgs, lib, ... }: {
  options = {
    module.program.${name}.enable = lib.mkEnableOption "Enables ${name}";
  };
  config = lib.mkIf config.module.program.${name}.enable {
    home.file.".zshrc".source = ./.zshrc;
    programs.zsh = {
      enable = true;
      # TODO: Configuration
    };
  };
}