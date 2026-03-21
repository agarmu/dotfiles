set shell := ["fish", "-c"]
export NIX_CONFIG := "warn-dirty = false"
export NH_OS_FLAKE := "."

# Main rebuild command -- formats, stages, rebuilds
sys *ARGS: prep
    nh os {{ARGS}}

# Build without switching (useful for testing)
build hostname=`hostname`:
    nom build .#nixosConfigurations.{{hostname}}.config.system.build.toplevel

# Format all nix files
nixfmt := `if command -v nixfmt >/dev/null; echo nixfmt; else; echo nix fmt --; end`
fmt:
    @[ ! -L result ] || rm result
    {{ nixfmt }} --quiet **.nix

# Prep: format, update flake, stage
prep: fmt
    nix flake update
    git add .
