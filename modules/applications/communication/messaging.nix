{
  flake.modules.homeManager.gui =
    { pkgs, ... }:

    {
      home.packages = with pkgs; lib.mkIf (lib.meta.availableOn stdenv.hostPlatform slack) [ slack ];
    };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      programs.vesktop.enable = true;
      stylix.targets.vesktop.enable = false;
      home.packages = with pkgs; [
        (weechat.override {
          configure = _: {
            scripts = with weechatScripts; [ wee-slack ];
          };
        })
      ];
    };
}
