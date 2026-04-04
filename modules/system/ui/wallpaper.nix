_: {
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ swww ];

      programs.niri.settings = {
        overview.workspace-shadow.enable = false;
        layout.background-color = "transparent";
        layer-rules = [
          {
            matches = [
              { namespace = "^swww.*$"; }
            ];
            place-within-backdrop = true;
          }
        ];

        spawn-at-startup = [
          {
            argv = [
              "swww-daemon"
              "-l"
              "background"
              "-n"
              "overview"
            ];
          }
        ];
      };
    };
}
