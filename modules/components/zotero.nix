{ lib, ... }:
{
  /*
    TODO
    pending: zotero 8 in nixpkgs
  */
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = lib.optional pkgs.stdenv.isDarwin [ pkgs.zotero ];
    };
}
