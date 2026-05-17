{
  flake.modules.nixos.base = {
    services.udisks2.enable = true;
  };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      services.udiskie.enable = true;
      home.packages = with pkgs; [ udiskie ];
    };
}
