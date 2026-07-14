{
  flake.modules.homeManager.dev = { pkgs, ... }: {
    programs.zed-editor = {
      enable = true;
      # TODO: change back once https://github.com/NixOS/nixpkgs/pull/541713 is merged
      package = pkgs.zed-editor.overrideAttrs (prevAttrs: {
        buildInputs = (prevAttrs.buildInputs or [ ]) ++ [ pkgs.git ];
      });
      userSettings = {
        telemetry = {
          metrics = false;
          diagnostics = false;
        };
      };
    };
  };
}
