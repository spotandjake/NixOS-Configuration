{ config, lib, systemConfig, ... }:

let
  name = "darwin";
in {
  options.module.${name} = {
    enable = lib.mkEnableOption "Enable Darwin Configuration";
  };

  config = lib.mkIf config.module.${name}.enable {
    programs.zsh.enable = true;
    security.pam.enableSudoTouchIdAuth = true; # Enable fingerprint sudo
    system.stateVersion = systemConfig.stateVersion;
    system.activationScripts.postUserActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
    nix.extraOptions = lib.optionalString (systemConfig.platform == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    nix.linux-builder.enable = true;
  };
}