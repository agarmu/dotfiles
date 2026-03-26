pkgs:
let
  inherit (pkgs) lib;
  packageFiles =
    builtins.readDir ./.
    |> builtins.attrNames
    |> builtins.filter (f: f != "default.nix" && lib.hasSuffix ".nix" f);
in
{
  mukul =
    packageFiles
    |> map (file: {
      name = lib.removeSuffix ".nix" file;
      value = pkgs.callPackage ./${file} { };
    })
    |> lib.listToAttrs;
}
