{
  inputs,
  ...
}:
{
  flake-file.inputs.nhx = {
    url = "github:Ra77a3l3-jar/nhx";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      imports = [ inputs.nhx.homeManagerModules.nhx ];

      programs.nhx = {
        enable = true;
        # nhx's plugins require the Steel event-system API, including
        # editor-document-diagnostic-counts.  Override the nested
        # steelix-unwrapped derivation rather than adding another flake input.
        package = pkgs.steelix.override {
          helix-unwrapped = pkgs.helix-unwrapped.overrideAttrs (
            _final: _old: {
              version = "0-unstable-2026-08-23";
              src = pkgs.fetchFromGitHub {
                owner = "mattwparas";
                repo = "helix";
                rev = "5a8635beda77414850a2b9604aa0643e4713db3b";
                hash = "sha256-7mUAINEKnPPCHqiXT+zU5bve4dqcggdjBuHRInhTGEY=";
              };
              cargoBuildFlags = [
                "--package"
                "helix-term"
                "--features"
                "steel,git"
              ];
              doInstallCheck = false;
            }
          );
        };
      };
    };

}
