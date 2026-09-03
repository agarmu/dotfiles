let
  identity = {
    email = "vcs@agarmu.com";
    name = "Mukul Agarwal";
  };
in
{
  flake.modules.homeManager.base =
    { pkgs, config, ... }:
    {
      programs.nixvim.plugins.treesitter.grammarPackages =
        with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          diff
          git_config
          git_rebase
          gitcommit
        ];
      home.packages = with pkgs; [
        difftastic
      ];
      programs.git = {
        enable = true;
        package = pkgs.gitFull;
        settings = {
          user = identity;
          init.defaultBranch = "main";

          # Show the staged diff in the commit message editor.
          commit.verbose = true;

          fetch = {
            # Remove stale remote-tracking branches when fetching.
            prune = true;
            # Refresh the commit graph after fetches to speed up history queries.
            writeCommitGraph = true;
          };

          # Set up a new branch's upstream on its first push.
          push.autoSetupRemote = true;
          # Remember conflict resolutions and reuse them when possible.
          rerere.enabled = true;
          # Include the common ancestor in conflict markers.
          merge.conflictStyle = "zdiff3";
          diff = {
            # Produce clearer diffs for code with repeated or moved lines.
            algorithm = "histogram";
            # Highlight code that moved instead of treating it as new code.
            colorMoved = "default";
          };
          rebase = {
            # Stash dirty work automatically before a rebase, then restore it.
            autoStash = true;
            # Automatically arrange fixup and squash commits during rebases.
            autoSquash = true;
            # Move other local branch refs that point into rewritten history.
            updateRefs = true;
          };

          # List recently updated branches first.
          branch.sort = "-committerdate";
          # Sort tags by version number instead of lexicographically.
          tag.sort = "version:refname";
          # Show the number of saved stashes in git status.
          status.showStash = true;
          # Use compact columns for supported commands in a terminal.
          column.ui = "auto";
          # Offer to run the intended command after a typo.
          help.autocorrect = "prompt";

          alias = {
            c = "commit";
            cl = "clone";
            co = "checkout";
            s = "status";
            sw = "switch";
            br = "switch";
            l = "log";
            lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";

            d = "diff";
            ds = "diff --staged";
            dt = "difft";
            dst = "difft --staged";
            difft = "-c diff.external=difft diff";
            ld = " log --ext-diff";
            ldt = "-c diff.external=difft log --ext-diff";
            dshow = "show --ext-diff";
            dtshow = "-c diff.external=difft show --ext-diff";
          };
        };
        lfs = {
          enable = true;
          skipSmudge = false;
        };
        signing = {
          key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
          signByDefault = true;
          format = "ssh";
        };
      };

      programs.jujutsu = {
        enable = true;
        settings = {
          user = identity;
          signing = {
            behavior = "own";
            backend = "ssh";
          };
        };
      };
      programs.jjui.enable = true;

      programs.lazygit.enable = true;
    };
}
