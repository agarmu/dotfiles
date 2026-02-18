_: {
  # enable only on host millet
  flake.modules.nixos.host-millet =
    { config, ... }:
    {
      services.thelounge = {
        enable = true;
        dataDir = "/srv/thelounge";
        port = 9000;
        extraConfig = {
          reverseProxy = true;
          prefetch = true;
          fileUpload.enable = true;
        };
      };
    };
}
