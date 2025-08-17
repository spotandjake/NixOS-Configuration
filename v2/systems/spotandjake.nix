{ platforms }: {
  username = "spotandjake";
  platform = platforms.darwinArm;
  systemConfiguration = {
    programs = {
      discord.enable = true;
    };
    settings = {};
  };
}