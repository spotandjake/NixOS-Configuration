{ config
, loader
, homeModules
, ...
}: loader.mkProgram {
  inherit config;
  name = "zsh";
  options = {};
  setup = {
    home.file.".zshrc".source = "${homeModules}/zsh/.zshrc";
    programs.zsh = {
      enable = true;
      # TODO: Configuration
    };
  };
}