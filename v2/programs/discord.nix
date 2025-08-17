{ sources, platforms }: {
  name = "git";
  platforms = [platforms.darwinArm];
  program = sources.nixpkgs "discord"; # I wonder if I can use reflection here
  # Configurations
  configuration = { # TODO: ensure we run a check that we are not overwriting
    location = ""; # Copies the given list of files to the given location
  };
}