{pkgs, ...}: {
  services = {
    spacebar = {
      enable = false;
      package = pkgs.spacebar;
    };
    tailscale = {
      enable = false;
    };
    yabai = {
      enable = false;
    };
  };
}
