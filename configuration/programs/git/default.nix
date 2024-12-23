{ config, lib, ... }:
with lib;
let
  name = "git";
  cfg = config.program."${name}";
in {
  options.program.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
     programs.git = {
      enable = true;
      userName = "Spotandjake";
      userEmail = "spotandjake@hotmail.com";

      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINeBcwM1G2GjkhLxKFiLUv4yO4nfYJLuBTOy4A93TOqi";
        signByDefault = true;
        gpgPath = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      aliases = {
        lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
        lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
        lg = "lg1";
      };
      ignores = [ ".DS_Store" ];
    };
  };
}