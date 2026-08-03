{
  flake.modules.homeManager.ai =
    { config, lib, ... }:
    {
      programs.claude-code = {
        enable = false;

        settings = {
          theme = "light";
          includeCoAuthoredBy = true;
          systemPrompt = lib.concatStringsSep "\n\n" (lib.attrValues config.ai.shared.rules);
          permissions = {
            defaultMode = "acceptEdits";
            allow = [
              "Bash(git diff:*)"
              "Bash(git log:*)"
              "Bash(git status:*)"
              "Bash(git show:*)"
              "Bash(nix fmt:*)"
              "Bash(nix build:*)"
              "Bash(nix flake check:*)"
              "Bash(cargo build:*)"
              "Bash(cargo test:*)"
              "Bash(cargo check:*)"
              "Bash(cargo clippy:*)"
              "Bash(sbt compile:*)"
              "Bash(sbt test:*)"
            ];
            ask = [
              "Bash(git push:*)"
              "Bash(git reset:*)"
              "Bash(git rebase:*)"
              "Bash(rm:*)"
            ];
            deny = [
              "Bash(git push --force:*)"
              "Bash(rm -rf:*)"
            ];
          };
        };

        skills = lib.mapAttrs (name: agent: ''
          ---
          name: ${name}
          description: ${agent.description}
          tools: ${lib.concatStringsSep ", " agent.tools}
          ---
          ${agent.prompt}
        '') config.ai.shared.agents;

        commands = lib.mapAttrs (_name: cmd: ''
          ---
          description: ${cmd.description}
          tools: ${lib.concatStringsSep ", " cmd.tools}
          ---
          ${cmd.prompt}
        '') config.ai.shared.tools;

        lspServers = {
          rust = {
            command = "rust-analyzer";
            args = [ ];
            extensionToLanguage.".rs" = "rust";
          };
          scala = {
            command = "metals";
            args = [ ];
            extensionToLanguage = {
              ".scala" = "scala";
              ".sbt" = "sbt";
              ".sc" = "scala";
            };
          };
          nix = {
            command = "nixd";
            args = [ ];
            extensionToLanguage.".nix" = "nix";
          };
        };

        outputStyles = {
          concise = ''
            Be terse. Lead with the answer or action — no preamble, no summary at the end.
            Prefer bullet points over prose. Skip praise and filler phrases.
            Code blocks only when showing actual code or commands.
          '';
          detailed = ''
            Explain thoroughly. Cover motivation, approach, trade-offs, and alternatives considered.
            Use headers to organise longer responses. Include examples where helpful.
          '';
        };
      };
    };
}
