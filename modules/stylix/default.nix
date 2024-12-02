{ pkgs
, lib
, self
, config
, hostname
, ...
}: 

with lib;

let
  cfg = config.module.stylix;

  theme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  wallpaper = "${self}/assets/grey_gradient.png";
  cursorSize = if hostname == "nbox" then 24 else 14;
in {
  options = {
    module.stylix.enable = mkEnableOption "Enables stylix";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      image = wallpaper;
      autoEnable = true;
      polarity = "dark";

      base16Scheme = theme;

      opacity = {
        applications = 1.0;
        terminal     = 1.0;
        popups       = 1.0;
        desktop      = 1.0;
      };

      cursor = {
        name    = "Vimix-cursors";
        package = pkgs.vimix-cursors;
        size    = cursorSize;
      };
    };
  };
}

