_: {
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.delta = {
        enable = true;
        enableGitIntegration = true;
      };
    };
}
