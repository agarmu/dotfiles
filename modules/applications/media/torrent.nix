{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [
        # TODO: switch back once https://github.com/NixOS/nixpkgs/pull/541651 is merged
        pkgs.stable.qbittorrent
      ];
    };
}
