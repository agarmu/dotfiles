{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        zstd
        brotli
        gzip
        zip
        unzip
      ];
    };
}
