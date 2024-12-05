let
  sharedMinDev = [
    {
      module.program.nushell.enable = true;
      # programs.git.enable = true;
    }
  ];
  sharedDevShell = [
    {
      # programs
      module.program.vscode.enable = true;
      module.program.gitkraken.enable = true;
      module.program.yazi.enable = true;
    }
  ];
  sharedWorkStation = [
    {
      # General
      module.program.arc-browser.enable = true;
      module.program.discord.enable = true;
      module.program.spotify.enable = true;
      module.program.obsidian.enable = true;
    }
  ];
in
{
  # User Specific Configurations
  users = {
    spotandjake = {
      homebrew = {
        enable = true;
        casks = [
          "lunar"
        ];
      };
      darwin = [
        {
          module.program.raycast.enable = true;
          module.program.iterm2.enable = true;
        }
      ];
      shared = sharedDevShell ++ sharedMinDev ++ sharedWorkStation;
    };
  };
  # Individual Systems
  systems = {
    JakesMacBook = {
      username = "spotandjake";
      platform = "aarch64-darwin";
      stateVersion = 5;
    };
  };
}