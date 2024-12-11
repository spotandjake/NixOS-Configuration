{ config
, mkProgram
, homeModules
, ...
}: mkProgram {
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