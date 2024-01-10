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
  typst = pkgs.vimUtils.buildVimPlugin {
    name = "typst.vim";
    src = pkgs.fetchFromGitHub {
      owner = "kaarmu";
      repo = "typst.vim";
      rev = "630bb8b7faf1fe02c253673a37a70c135ad43a40";
      hash = "sha256-lm6V0USAzFEIpziGC1kx7X4rqYOXCfztte9w62MlZp8=";
    };
  };

}
