{ lib, ... }: {
  perSystem = { system, ... }: {
    _module.args = {
      nixpkgs = {
        hostPlatform = system;
        config = {
          allowUnfree = true;
        };
        nix = {
          # TODO: Look into this
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
          # TODO: Check if we have linux-builder enabled
        };
        overlays = [../overlays];
      };
    };
  };
}