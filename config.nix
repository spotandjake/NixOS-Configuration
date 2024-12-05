let
  sharedMinDev = [
    {
      module = {
        program = {
          nushell.enable = true;
          git.enable = true;
        };
      };
    }
  ];
  sharedDevShell = [
    {
      module = {
        program = {
          vscode.enable = true;
          gitkraken.enable = true;
          yazi.enable = true;
        };
      };
    }
  ];
  sharedWorkStation = [
    {
      module = {
        program = {
          arc-browser.enable = true;
          discord.enable = true;
          spotify.enable = true;
          obsidian.enable = true;
        };
      };
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
      # Mac Specific Configuration
      darwin = [
        {
          module = {
            program = {
              raycast.enable = true;
              iterm2.enable = true;
            };
          };
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