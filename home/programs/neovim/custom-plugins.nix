{pkgs, ...}: {
  catppuccin = pkgs.vimUtils.buildVimPlugin {
    name = "catppuccin";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "nvim";
      rev = "b573866ef64122119668f375ebb794bcb3b518e2";
      hash = "sha256-9401fBGF1up2wVaNZIdLW408/lfMdh8wBabaUcc6oqc=";
    };
  };
}
