pkgs:
let
  inherit (pkgs) lib;
in
{
  mukul =
    builtins.readDir ./.
    |> lib.mapAttrsToList (
      name: kind:
      let
        path = ./. + "/${name}/default.nix";
      in
      lib.optional (kind == "directory" && builtins.pathExists path) {
        inherit name path;
      }
    )
    |> lib.concatLists
    |> map (pkg: {
      inherit (pkg) name;
      value = pkgs.callPackage pkg.path { };
    })
    |> lib.listToAttrs;
}
