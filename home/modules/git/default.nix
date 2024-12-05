{ config
, mkProgram
, ...
}: mkProgram {
  inherit config;
  name = "git";
  options = {};
  setup = {
    programs.git = {
      enable = true;
      userName = "Spotandjake";
      userEmail = "spotandjake@hotmail.com";

      signing = {
        key = "32B60BCA157296EE";
        signByDefault = true;
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
