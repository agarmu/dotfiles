_: {
  # enable only on host millet
  flake.modules.nixos.host-millet =
    { config, ... }:
    {
      services.thelounge = {
        enable = true;
        public = true;
        port = 9000;
      };
    };
}
