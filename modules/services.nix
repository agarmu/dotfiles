{pkgs, ...}: {
  services = {
    spacebar = {
      enable = false;
      package = pkgs.spacebar;
    };
    tailscale = {
      enable = true;
    };
    yabai = {
      enable = false;
    };
  };
}
