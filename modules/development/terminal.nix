{
  flake.modules.homeManager.gui = {
    programs.ghostty = {
      enable = true;
      settings = {
        window-padding-x = 15;
        window-padding-y = 15;
        window-decoration = false;
        cursor-style = "bar";
        cursor-style-blink = true;
      };
    };
  };
}
