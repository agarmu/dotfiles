{
  flake.modules.homeManager.ai =
    { config, ... }:
    {
      programs.pi-coding-agent = {
        enable = true;
        configDir = "${config.xdg.configHome}/pi/agent";
        settings = {
          autoshare = false;
          autoupdate = false;
        };
      };
    };
}
