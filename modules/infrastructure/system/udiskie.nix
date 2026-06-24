{
  flake.modules.nixos.base = {
    services.udisks2.enable = true;
  };
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      services.udiskie.enable = true;
      home.packages = with pkgs; [ udiskie ];
    };
}
