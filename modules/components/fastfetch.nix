_: {
  flake.modules.homeManager.base = {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "small";
          padding.top = 1;
        };
        display.separator = " ";
        modules = [
          "title"
          {
            type = "separator";
            string = " ";
          }
          {
            type = "os";
            key = "OS";
            format = "{name}";
          }
          "memory"
          {
            type = "disk";
            key = "Disk";
          }
          {
            type = "localip";
            key = "IP";
          }
          {
            type = "separator";
            string = " ";
          }
          { type = "colors"; }
        ];
      };
    };
  };
}
