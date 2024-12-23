{ inputs, lib, pkgs, hostPlatform, ... }: {
  nixpkgs = {
    inherit hostPlatform;
    config = {
      allowUnfree = true;
    };
  };
  nix = {
    package = pkgs.nixVersions.latest;
    registry.s.flake = inputs.self;
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
    extraOptions = lib.optionalString (hostPlatform == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };
}