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
  typst-vim = pkgs.vimUtils.buildVimPlugin {
    name = "typst.vim";
    src = pkgs.fetchFromGitHub {
      owner = "kaarmu";
      repo = "typst.vim";
      rev = "630bb8b7faf1fe02c253673a37a70c135ad43a40";
      hash = "sha256-lm6V0USAzFEIpziGC1kx7X4rqYOXCfztte9w62MlZp8=";
    };
  };
  nvim-tree = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-tree";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-tree";
      repo = "nvim-tree.lua";
      rev = "f1b3e6a7eb92da492bd693257367d9256839ed3d";
      hash = "sha256-D+wCJQuRj9mvgLd0DaiYgqghDYDwfux9zlEb/vIvaqA=";
    };
  };
}
