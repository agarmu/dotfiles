{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      programs.pi-coding-agent = {
        enable = true;
        configDir = "$HOME/.pi/agent";
        settings = {
          autoshare = false;
          autoupdate = false;
          tuiMode = "fullscreen";
          packages =
            (with pkgs.pi-extensions; [
              better-openai
              context
              context-guard
              dynamic-footer
              fff
              loop
              model-picker
              notify
              pi-sandbox
              rtk
              scratchpad
              todo
              subagents
              web-search
            ])
            |> map (x: "${x}");
        };
      };
    };
}
