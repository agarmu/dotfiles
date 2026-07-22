{
  flake.modules.darwin.base = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.omniwm ];
  };
  flake.modules.homeManager.darwin = { pkgs, ... }: {
    launchd.agents.omniwm = {
      enable = false;
      config = {
        Label = "org.bartusrb.omniwm";
        # Provide the exact path to the wrapper we built earlier
        ProgramArguments = [ "${pkgs.omniwm}/bin/OmniWM" ];

        # Start automatically on login
        RunAtLoad = true;

        # Restart it if it crashes
        KeepAlive = true;

        # Helpful for debugging why the WM might fail to start
        StandardOutPath = "/tmp/omniwm.out";
        StandardErrorPath = "/tmp/omniwm.err";

        # Window managers often need to ensure the GUI is fully loaded
        LimitLoadToSessionType = "Aqua";
      };
    };
  };
}
