_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.niri.settings.window-rules = [
      {
        matches = [
          {
            app-id = "org.myapp.MyApp";
            title = "My Cool App";
          }
          { title = "Second App"; }
        ];

        excludes = [
          { app-id = ''\.unwanted\.''; }
        ];

        default-column-width = {
          proportion = 0.75;
        };
        open-on-output = "eDP-1";
        open-maximized = true;
        open-fullscreen = true;
      }

      {
        matches = [
          { app-id = ''^org\.wezfurlong\.wezterm$''; }
        ];

        default-column-width = { };
      }
    ];
  };
}
