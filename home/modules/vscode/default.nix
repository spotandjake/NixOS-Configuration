{ lib
, config
, userConfig
, ...
}:

with lib;
let
  cfg = config.module.vscode;
in {
  options = {
    module.vscode.enable = mkEnableOption "Enables vscode";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      enableUpdateCheck = true;
      # TODO: Point our shell towards the nix version
      # TODO: Move settings into nix
      # TODO: Cleanup settings
      # TODO: I want to save my theme locally
      userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
      keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);
      # TODO: Setup extensions
    };
  };
}