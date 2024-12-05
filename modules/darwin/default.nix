{ inputs, config, lib, systemConfig, userConfig, ... }:

let
  name = "darwin";
in {
  options.module.${name} = {
    enable = lib.mkEnableOption "Enable Darwin Configuration";
  };

  config = lib.mkIf config.module.${name}.enable {
    programs.zsh.enable = true;
    security.pam.enableSudoTouchIdAuth = true; # Enable fingerprint sudo
    # System setup
    system = {
      inherit (systemConfig) stateVersion; # Set the nix-darwin config version
      # Set the commit of the build
      configurationRevision = inputs.rev or inputs.dirtyRev or null;
      # Updates the mac system without login/logout
      activationScripts.postUserActivation.text = ''
        # Following line should allow us to avoid a logout/login cycle
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
    };
    # Some extra nix features
    nix = {
      # Allow building for x86 with rosetta on M1
      extraOptions = lib.optionalString (systemConfig.platform == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
      # Allow cross compiling to linux on M1
      linux-builder.enable = true;
    };
    # Homebrew setup from config
    inherit (userConfig) homebrew;
  };
}