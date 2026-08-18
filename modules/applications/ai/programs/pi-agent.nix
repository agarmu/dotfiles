{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      programs.pi-coding-agent = {
        enable = true;
        settings = {
          autoshare = false;
          autoupdate = false;
          tuiMode = "fullscreen";
          packages =
            (with pkgs.pi-extensions; [
              better-openai
              context
              context-guard
              btw
              fancy-footer
              fff
              goal
              model-picker
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
