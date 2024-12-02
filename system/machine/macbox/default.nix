{ inputs
, pkgs
, ...
}: 

{
  # TODO: Add my packages
  # TODO: Audit the packages here
  # TODO: Is this where my darwin configs go????
  environment.systemPackages = with pkgs; [ 
    vim
    home-manager
    nerdfonts
    alacritty
  ];

  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  programs.zsh.enable = true;
  # programs.fish.enable = true;

  system.configurationRevision = inputs.rev or inputs.dirtyRev or null;
}

