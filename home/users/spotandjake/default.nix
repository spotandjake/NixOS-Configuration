{ isWorkstation
, isLinux
, ...
}:

{
  nixpkgs.overlays = [  ];

  stylix.targets = {
    # TODO: Configure This?????
    vscode.enable = false;
    helix.enable = false;
  };

  module = {
    # TODO: Configure this????
    alacritty.enable = isWorkstation;
    vscode.enable    = isWorkstation;
    emacs.enable     = isWorkstation;
    zathura.enable   = isWorkstation;
    stylix.enable    = isWorkstation;

    chrome.enable      = isLinux && isWorkstation;
    firefox.enable     = isLinux && isWorkstation;
    librewolf.enable   = isLinux && isWorkstation;
    thunderbird.enable = isLinux && isWorkstation;
    foot.enable        = isLinux && isWorkstation;
    ssh.enable         = isLinux && isWorkstation;

    btop.enable           = true;
    eza.enable            = true;
    git.enable            = true;
    fzf.enable            = true;
    htop.enable           = true;
    ripgrep.enable        = true;
    lazygit.enable        = true;
    neofetch.enable       = true;
    fastfetch.enable      = true;
    nvim.enable           = true;
    helix.enable          = true;
    password-store.enable = true;
    zsh.enable            = true;
    fish.enable           = true;
    yazi.enable           = true;

    user = {
      impermanence.enable = isLinux && isWorkstation;

      packages.enable = true;
    };
  };
}

