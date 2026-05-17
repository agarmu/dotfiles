{
  flake.modules.nixos.base.web-services.abook = {
    host = "millet";
    port = 8000;
  };

  flake.modules.nixos.host-millet =
    { config, ... }:
    {
      sops.secrets."audiobookshelf-token-secret" = {
        owner = "audiobookshelf";
      };

      services.audiobookshelf = {
        enable = true;
        host = "127.0.0.1";
        port = 8000;
      };

      sops.templates."audiobookshelf-env" = {
        content = ''
          TOKEN_SECRET=${config.sops.placeholder."audiobookshelf-token-secret"}
        '';
        owner = "audiobookshelf";
      };

      systemd.services.audiobookshelf.serviceConfig.EnvironmentFile =
        config.sops.templates."audiobookshelf-env".path;
    };
}
