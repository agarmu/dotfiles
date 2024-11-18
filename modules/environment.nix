{pkgs, ...} : {
  environment.systemPackages = with pkgs; [
    coreutils
    coreutils-prefixed
    binutils
    git
  ];
  environment.variables = {
    HOMEBREW_NO_ANALYTICS = "1";
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
  };
}
