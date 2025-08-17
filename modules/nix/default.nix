{ inputs, lib, pkgs, hostPlatform, ... }: {
  nixpkgs = {
    inherit hostPlatform;
    config = {
      allowUnfree = true;
    };
  };
  nix = {
    enable = true;
    package = pkgs.nixVersions.latest;
    registry.s.flake = inputs.self;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      download-buffer-size = 524288000; # 500MB in bytes
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
    # Allows us to use linux packages
    linux-builder = {
      enable = true;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      config.boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
    };
  };
}
