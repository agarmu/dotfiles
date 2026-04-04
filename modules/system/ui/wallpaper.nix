_: {
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ awww ];

      programs.niri.settings = {
        overview.workspace-shadow.enable = false;
        layout.background-color = "transparent";
        layer-rules = [
          {
            matches = [
              { namespace = "^awww.*$"; }
            ];
            place-within-backdrop = true;
          }
        ];

        spawn-at-startup = [
          {
            argv = [
              "awww-daemon"
              "-l"
              "background"
            ];
          }
        ];
      };
    };
}
