{pkgs, ...}: {
  services = {
    spacebar = {
      enable = true;
      package = pkgs.spacebar;
    };
    tailscale = {
      enable = true;
    };
    yabai = {
      enable = true;
    };
  };
}
