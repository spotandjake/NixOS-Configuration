{ pkgs
, inputs
, ...
}:

{
  home = {
    # Software
    packages = with pkgs; [
      # Utils
      inputs.any-nix-shell
    ];
  };

  imports = [
    ../../../modules/nix
    ../../modules
  ];

  module = {
    # TODO: Configure This???
    git.enable = true;
    zsh.enable = true;

    nix-config = {
      enable = true;
      useNixPackageManagerConfig = false;
    };
  };
}

