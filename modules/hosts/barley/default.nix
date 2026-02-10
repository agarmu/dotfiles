{
  inputs,
  ...
}:
{
  flake.modules.darwin.macbook = {
    imports = with inputs.self.modules.darwin; [
      base
    ];
    networking.hostName = "barley";

    # homebrew = {
    #   enable = true;
    #   masApps = {
    #     "Numbers" = 409203825;
    #     "Pages" = 409201541;
    #     "Keynote" = 409183694;
    #     "iMovie" = 408981434;
    #   };
    # };
  };

  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" "macbook";
}
