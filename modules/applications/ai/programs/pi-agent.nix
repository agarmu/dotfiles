{
  flake.modules.homeManager.ai =
    { config, pkgs, ... }:
    {
      programs.pi-coding-agent = {
        enable = true;
        configDir = "${config.xdg.configHome}/pi/agent";
        settings = {
          autoshare = false;
          autoupdate = false;
          packages =
            (with pkgs.pi-extensions; [
              better-openai
              context
              context-guard
              guardrails
              notify
              todo
              statusline
              subagents
              web-search
            ])
            |> map (x: "${x}");
        };
      };
    };
}
