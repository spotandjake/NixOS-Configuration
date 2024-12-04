let
  # Isolated Configurations - shared between users
  configurations = {
    sharedMinDev = [
      {
        programs.nushell = true;
        # programs.git.enable = true;
      }
    ];
    sharedDevShell = [
      {
        # programs
        programs.vscode = true;
        programs.gitkraken = true;
        programs.yazi = true;
      }
    ];
    sharedWorkStation = [
      {
        # General
        programs.arc-browser = true;
        programs.discord = true;
        programs.spotify = true;
        programs.obsidian = true;
      }
    ];
  };
in
{
  # Individual Systems
  systems = {
    JakesMacBook = {
      username = "spotandjake";
      platform = "aarch64-darwin";
      system = "darwin";
      stateVersion = 4;
      isWorkstation = true;
    };
  };
  # User Specific Configurations
  users = {
    # TODO: Wrap this as a function, to merge the configurations
    spotandjake = {
      darwin = [
        {
          programs.raycast = true;
          programs.iterm2 = true;
        }
      ];
      shared =
        configurations.sharedDevShell
        ++ configurations.sharedMinDev
        ++ configurations.sharedWorkStation;
    };
  };
}
