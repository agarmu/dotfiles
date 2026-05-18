{ lib, ... }:
{
  flake.modules.homeManager.ai = {
    options.ai.shared.rules = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.lines;
    };

    config.ai.shared.rules = {
      code-style = ''
        # Code Style

        - Prefer clarity over cleverness
        - Keep functions small and single-purpose
        - Avoid deep nesting; early-return or extract helper
        - No commented-out code; use version control
        - No `TODO` without a ticket reference or date

        ## Rust
        - Use `?` for error propagation; avoid `.unwrap()` in library code
        - Prefer `thiserror` for library errors, `anyhow` for binaries
        - Run `clippy` before committing

        ## Scala
        - Prefer `cats`/`cats-effect` for effectful code
        - Avoid mutable state; use `Ref` or `IO` for shared state
        - Use `given`/`using` over implicit conversions
        - Format with `scalafmt`

        ## Nix
        - Use `lib.mkDefault` / `lib.mkForce` explicitly rather than relying on priority
        - Avoid `rec` at top level in modules
      '';

      git = ''
        # Git Workflow

        - One logical change per commit
        - Never amend published commits (on shared branches)
        - Never force-push to `main` or `master`
        - Branch names: `<type>/<short-description>` (e.g. `fix/null-deref`, `feat/oauth`)
        - Always check `git diff --staged` before committing to catch accidental includes
      '';

      security = ''
        # Security

        - Never commit secrets, tokens, or passwords
        - Never log sensitive data (tokens, PII, passwords)
        - Validate all external input at system boundaries
        - Run `cargo audit` / `sbt dependencyCheck` before releases
        - Use constant-time comparison for secrets (`subtle` crate in Rust)
        - Prefer authenticated encryption (AES-GCM, ChaCha20-Poly1305)
      '';

      testing = ''
        # Testing

        - Write tests before marking a task done
        - Test behaviour, not implementation — don't assert on private internals
        - One logical assertion per test case
        - Test names: `<subject>_<scenario>_<expected>` (e.g. `parse_emptyInput_returnsNone`)
        - Prefer real I/O over mocks at integration boundaries

        ## Rust
        - Unit tests live in the same file under `#[cfg(test)]`
        - Integration tests live in `tests/`
        - Use `proptest` or `quickcheck` for property-based tests on pure functions

        ## Scala
        - Use `munit` or `weaver-test` for effect-aware tests
        - Use `ScalaCheck` for property-based tests
        - Tag slow tests with `@slow` so they can be excluded in CI

        ## Nix
        - Use `nixosTest` for system-level integration tests
        - Test modules with `lib.evalModules` in unit tests
      '';
    };
  };
}
