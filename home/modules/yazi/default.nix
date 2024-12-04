{ config
, loader
, ...
}: loader.mkProgram {
  inherit config;
  name = "yazi";
  options = {};
  setup = {
    programs.yazi = {
      enable = true;
      # This is off because it causes an issue in our env.nu
      enableNushellIntegration = false;
    };
  };
}