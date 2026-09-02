_: {
  flake.modules.homeManager.ai = _: {
    programs.omp = {
      enable = false;
      settings = {
        autoshare = false;
        autoupdate = false;
        compaction.enabled = true;
        tuiMode = "fullscreen";
      };
    };
  };
}
