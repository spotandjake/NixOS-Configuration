{ config
, mkProgram
, ...
}: mkProgram {
  inherit config;
  name = "direnv";
  options = {};
  setup = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}