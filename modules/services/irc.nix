_: {
  # enable only on host millet
  flake.modules.nixos.host-millet =
    { config, ... }:
    {
      services.thelounge = {
        enable = true;
        port = 9000;
        extraConfig = {
          reverseProxy = true;
          prefetch = true;
          fileUpload.enable = true;
        };
      };
    };
}
