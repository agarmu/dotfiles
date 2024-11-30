{...}: {
  programs.git = {
    enable = true;
    aliases = {
      c = "commit";
      cl = "clone";
      co = "checkout";
      d = "diff";
      ds = "diff --staged";
      s = "status";
      l = "log";
    };
    delta.enable = true;
    lfs = {
      enable = true;
      skipSmudge = false;
    };
    signing = {
      key = null;
      signByDefault = true;
    };
    userEmail = "agarmukul23@gmail.com";
    userName = "Mukul Agarwal";
    extraConfig = {
      core = {
        pager = "bat";
      };
    };
  };
}
