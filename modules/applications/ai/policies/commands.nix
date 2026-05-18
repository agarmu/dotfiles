{ lib, ... }:
{
  flake.modules.homeManager.ai = {
    options.ai.shared.tools = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            description = lib.mkOption { type = lib.types.str; };
            tools = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
            prompt = lib.mkOption { type = lib.types.lines; };
          };
        }
      );
    };

    config.ai.shared.tools = {
      commit = {
        description = "Stage and commit changes with a well-formed message";
        prompt = ''
          ## Context

          - Current status: !`git status`
          - Staged diff: !`git diff --cached`
          - Unstaged diff: !`git diff`
          - Recent commits: !`git log --oneline -5`

          ## Task

          1. Review all changes above
          2. Stage only the relevant files (never `.env`, secrets, or unrelated changes)
          3. Write a commit message following Conventional Commits:
             - `feat:` new feature
             - `fix:` bug fix
             - `docs:` documentation changes
             - `style:` formatting, etc. (no code change)
             - `refactor:` refactoring
             - `perf:` performance improvement
             - `test:` adding/fixing tests
             - `build:` build system or dependencies
             - `ci:` CI configuration
             - `chore:` other (no src/test change)
             - `revert:` revert previous commit
          4. Keep the subject line ≤72 chars, imperative mood ("add X" not "added X")
          5. Add a body if the why isn't obvious
        '';
      };

      explain = {
        description = "Explain what a piece of code does";
        prompt = ''
          Explain the code or file the user has specified. Cover:

          1. **Purpose** – what problem it solves
          2. **How it works** – key logic, data flow, important invariants
          3. **Entry points** – how callers use it
          4. **Non-obvious parts** – tricky edge cases or design decisions

          Read the relevant files before answering. Check git log for context if the history is informative.
        '';
      };

      fix-issue = {
        description = "Fix a bug or implement a feature from a description";
        prompt = ''
          ## Task

          Fix or implement: $ARGUMENTS

          ## Process

          1. Read relevant code before making any changes
          2. Identify the minimal change needed
          3. Make the change
          4. Verify with tests or a build if applicable
          5. Do not add unrelated changes or refactors
        '';
      };

      pr = {
        description = "Push branch and open a pull request";
        prompt = ''
          ## Context

          - Branch: !`git branch --show-current`
          - Commits vs main: !`git log --oneline main..HEAD`
          - Diff vs main: !`git diff main..HEAD --stat`

          ## Task

          1. Push the current branch if not already pushed
          2. Draft a PR title (≤70 chars) and body:
             - **Summary**: what and why (2-4 bullets)
             - **Test plan**: what to verify
          3. Open the PR with `gh pr create`
          4. Print the PR URL

          Do not merge. Do not request reviewers unless asked.
        '';
      };

      review = {
        description = "Review staged or recent changes";
        prompt = ''
          ## Context

          - Changes to review: !`git diff HEAD`
          - Recent commits: !`git log --oneline -10`

          ## Task

          Perform a concise code review of the changes above. Report:

          1. **Summary** – what the change does
          2. **Issues** – bugs, security problems, or style violations (file:line)
          3. **Suggestions** – improvements worth considering (optional)

          Be direct. Skip praise.
        '';
      };
    };
  };
}
