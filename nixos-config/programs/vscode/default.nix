{ config, lib, ... }:
with lib;
let
  name = "vscode";
  cfg = config.program."${name}";
in {
  options.program.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      # TODO: Point our shell towards the nix version
      # TODO: Move settings into nix
      # TODO: Cleanup settings
      # TODO: I want to save my theme locally
      profiles.default = {
        enableUpdateCheck = true;
        userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
        keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);
      };
      # TODO: Setup extensions
    };
  };
}