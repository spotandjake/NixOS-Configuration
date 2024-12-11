{ lib, hostPlatform, ... }: {
  nixpkgs = {
    hostPlatform = hostPlatform;
    config = {
      allowUnfree = true;
    };
    nix = {
      # TODO: Enable the package version here
      # package = pkgs.nixVersions.latest;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };
      optimise = {
        automatic = true;
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 14d";
      };
      # Allow cross builds if supported
      extraOptions = lib.optionalString (system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
    };
    overlays = [../../overlays];
  };
}