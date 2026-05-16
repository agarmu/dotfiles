{
  flake.modules.nixos.base.web-services.irc = {
    host = "millet";
    port = 9000;
  };

  flake.modules.nixos.host-millet = {
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
