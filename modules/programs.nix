_: {
  programs = {
    bash.enable = true;
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    info.enable = true;
    man.enable = true;
  };
}
