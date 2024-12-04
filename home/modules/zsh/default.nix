{ lib
, config
, userConfig
, homeModules
, ...
}:

with lib;

let
  cfg = config.module.zsh;
in {
  options = {
    module.zsh.enable = mkEnableOption "Enables zsh";
  };

  config = mkIf cfg.enable {
    home.file.".zshrc".source = "${homeModules}/zsh/.zshrc";
    # TODO: Proper setup
    programs.zsh = {
      enable = true;

      plugins = with inputs; [
        # TODO: Wakatime
      ];

      # shellAliases = {};

      # initExtraFirst = '''';

      # initExtra = '''';
    };
  };
}