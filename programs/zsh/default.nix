{ config, lib, pkgs, ... }:
with lib;
let
  name = "zsh";
  cfg = config.program."${name}";
in
{
  options.program.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      dotDir = config.home.homeDirectory + "/.config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        eval "$(${pkgs.fnm}/bin/fnm env --use-on-cd)"
        export PATH="/opt/homebrew/bin:$PATH"
      '';
      plugins = with pkgs; [
        {
          name = "zsh-syntax-highlighting";
          src = fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.6.0";
            sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
          };
          file = "zsh-syntax-highlighting.zsh";
        }
      ];
    };
  };
}
