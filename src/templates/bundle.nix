# This file is generated automatically by the `system-config` package.
{ config, lib, "%~ darwin.length != 0 ? 'isDarwin,' : '' %" "%~ nix.length != 0 ? 'isNix,' : '' %" ... }:
with lib;
let
  name = ""%~ name %"";
  cfg = config.bundle."${name}";
in {
  options.bundle.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    program = {
      # Darwin Programs
      "% darwin.forEach((program) => { %"
"%~ program.name %" = mkIf isDarwin {
        enable = "%~ program.enable %";
      };
      "% }); %"

      # Nix Programs
      "% nix.forEach((program) => { %"
"%~ program.name %" = mkIf isNix {
        enable = "%~ program.enable %";
      };
      "% }); %"

      # Shared Programs
      "% shared.forEach((program) => { %"
"%~ program.name %" = {
        enable = "%~ program.enable %";
      };
      "% }); %"

    };
  };
}