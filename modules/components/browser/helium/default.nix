{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.mukul.helium.override { enableWidevine = true; })
      ];
    };
}
