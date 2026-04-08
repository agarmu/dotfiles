pkgs:
let
  inherit (pkgs) lib;
  packageDefs =
    builtins.readDir ./.
    |> lib.mapAttrsToList (
      dir: kind:
      lib.optional (kind == "directory" && builtins.pathExists (./. + "/${dir}/default.nix")) {
        name = dir;
        path = ./. + "/${dir}/default.nix";
      }
    )
    |> lib.concatLists;
in
{
  mukul =
    packageDefs
    |> map (pkg: {
      inherit (pkg) name;
      value = pkgs.callPackage pkg.path { };
    })
    |> lib.listToAttrs;
}
