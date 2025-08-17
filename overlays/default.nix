{ lib, ... }:

{
  imports = builtins.filter (module: lib.pathIsDirectory module) (
    map (module: builtins.toString ./nixpkgs/. + "/${module}") (builtins.attrNames (builtins.readDir (builtins.toString ./nixpkgs/.)))
  );
}
