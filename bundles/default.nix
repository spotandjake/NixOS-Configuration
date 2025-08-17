{ ... }:

{
  imports = builtins.filter (module: module != builtins.toString ./. + "/default.nix") (
    map (module: builtins.toString ./. + "/${module}") (builtins.attrNames (builtins.readDir (builtins.toString ./.)))
  );
}
