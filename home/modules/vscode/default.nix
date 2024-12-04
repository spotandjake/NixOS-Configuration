{ config
, loader
, ...
}: loader.mkProgram {
  inherit config;
  name = "vscode";
  options = {};
  setup = {
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