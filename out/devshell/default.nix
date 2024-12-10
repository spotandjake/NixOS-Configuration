{
  # TODO: Read devShell from user devShell
  perSystem = { pkgs, ... }: {
    # For nix develop
    devShells.default = pkgs.mkShell {
      name = "flake-template";
      meta.description = "DevShell for Flake";

      # Env
      # TODO: Switch to vscode
      EDITOR = "${pkgs.helix}/bin/hx";

      # TODO: nushell
      shellHook = ''
        exec zsh
      '';

      # TODO: Customize packages to my liking
      packages = with pkgs; [
        yazi
        git
        curl
        zsh
      ];
    };
  };
}