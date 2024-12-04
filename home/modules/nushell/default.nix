{ config
, loader
, homeModules
, ...
}: loader.mkProgram {
  inherit config;
  # TODO: Add Configuration Files
  name = "nushell";
  options = {};
  setup = {
    programs.nushell = {
      enable = true;
      configFile.source = "${homeModules}/nushell/config.nu";
      envFile.source = "${homeModules}/nushell/env.nu";
    };
  };
}