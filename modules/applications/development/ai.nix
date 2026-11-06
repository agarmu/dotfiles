{ inputs, ... }:
{
  flake-file.inputs.agent-skills = {
    url = "github:Kyure-A/agent-skills-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake-file.inputs.mattpocock-skills = {
    url = "github:mattpocock/skills";
    flake = false;
  };

  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      imports = [ inputs.agent-skills.homeManagerModules.default ];

      programs.claude-code = {
        enable = true;
        settings = {
          # Built-in mitigation for account email in shell User-Agent headers.
          # It does not cover every outbound tool or script.
          enabledPlugins."cc-plugin-privacy@builtin" = true;
          syncClaudeAiPlugins = false;
          remoteControlAtStartup = false;
          disableAgentView = true;
          attribution = {
            commit = "";
            pr = "";
          };
          includeCoAuthoredBy = false; # legacy key, kept as a fallback
          # Hard block: reject any Bash call (git/jj commit, gh pr, ...) that
          # still tries to slip in Claude attribution.
          hooks.PreToolUse = [
            {
              matcher = "Bash";
              hooks = [
                {
                  type = "command";
                  command = toString (
                    pkgs.writeShellScript "claude-block-attribution" ''
                      cmd=$(${pkgs.jq}/bin/jq -r '.tool_input.command // empty')
                      if printf '%s' "$cmd" | ${pkgs.gnugrep}/bin/grep -qiE 'co-authored-by|generated with \[?claude|noreply@anthropic\.com'; then
                        echo "Blocked: do not add Co-Authored-By / Claude attribution to commits, PRs, or messages. Remove it and retry." >&2
                        exit 2
                      fi
                    ''
                  );
                }
              ];
            }
          ];
          permissions.defaultMode = "auto";
          sandbox = {
            enabled = true;
            autoAllowBashIfSandboxed = false;
          };
          env = {
            CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
          };
        };
      };
      programs.codex = {
        enable = true;
        mutableSettings = true;
        settings = {
          features.daemon_auto_start = false;
          web_search = "live";
          approval_policy = "on-request";
          approvals_reviewer = "auto_review";
          sandbox_mode = "workspace-write";
          shell_environment_policy.ignore_default_excludes = false;
          analytics.enabled = false;
          feedback.enabled = false;
          otel = {
            exporter = "none";
            metrics_exporter = "none";
            trace_exporter = "none";
            log_user_prompt = false;
          };
        };
      };

      programs.agent-skills = {
        enable = true;
        sources.mattpocock = {
          path = inputs.mattpocock-skills;
          subdir = "skills";
        };
        skills.enableAll = [ "mattpocock" ];
        targets.agents.enable = true;
        targets.claude.enable = true;
      };

      home.packages = with pkgs; [
        beads
        beads-viewer
        herdr
        herdr-gpui
      ];
    };
}
