{
  flake.modules.homeManager.linuxGui = {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "Nordwand Mono:size=14";
          terminal = "ghostty -e";
          lines = 10;
          width = 40;
          icons-enabled = true;
        };
        border.radius = 8;
      };
    };
  };
}
