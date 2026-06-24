{
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
      };
    };
}
