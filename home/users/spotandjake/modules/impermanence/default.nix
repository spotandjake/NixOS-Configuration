{ lib
, config
, username
, ...
}:

with lib;

let
  cfg = config.module.user.impermanence;  
in {
  options = {
    module.user.impermanence.enable = mkEnableOption "Enables home impermanence";
  };

  config = mkIf cfg.enable {
    home.persistence = {
      "/persist/home/${username}" = {
        allowOther = true;

        directories = [
          "Code"
          "Desktop"
          "Downloads"
          "Documents"
          "go"
          "Music"
          "Pictures"
          "Public"
          "Templates"
          "Videos"
          "VirtualBox VMs"
          "Trash"
          "Sync"
          ".ansible_inventory"
          ".docker"
          ".flutter-devtools"
          ".kube"
          ".m2"
          ".mozilla"
          ".librewolf"
          ".obsidian"
          ".themes"
          ".config/google-chrome"
          ".config/sops"
          ".config/vesktop"
          ".config/sops-nix"
          ".config/obsidian"
          ".config/Code"
          ".config/syncthing"
          ".config/pulse"
          ".local/share/fish"
          ".local/share/nix"
          ".local/share/containers"
          ".local/share/Trash"
          ".local/state"
          ".vscode"
          ".pki"
          ".ssh"
          ".gnupg"
        ];

        files = [
          ".bash_history"
          ".bash_logout"
          ".flutter"
          ".face"
          ".face.icon"
          ".zsh_history"
          ".cache/cliphist/db"
        ];
      };
    };
  };
}

