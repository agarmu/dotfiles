_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.niri.settings = {
      prefer-no-csd = true;
      window-rules = [
        {
          geometry-corner-radius =
            let
              r = 10.0;
            in
            {
              top-left = r;
              top-right = r;
              bottom-left = r;
              bottom-right = r;
            };
          clip-to-geometry = true;
        }
      ];
    };
  };
}
