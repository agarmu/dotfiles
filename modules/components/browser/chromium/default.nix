{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
      };
    };
}
