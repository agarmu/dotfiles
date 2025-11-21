{...}: {
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.info.enable = true;
  programs.man.enable = true;
}
