_: {
  flake.modules.homeManager.gui =
    { pkgs, ... }:

    {
      home.packages = with pkgs; lib.mkIf (lib.meta.availableOn stdenv.hostPlatform slack) [ slack ];
    };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vesktop
        (weechat.override {
          configure = _: {
            scripts = with weechatScripts; [ wee-slack ];
          };
        })
      ];
    };
  flake.modules.darwin.gui = _: {
    homebrew.casks = [ "vesktop" ];
  };
}
