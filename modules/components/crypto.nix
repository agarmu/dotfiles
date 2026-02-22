_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        openssl # cryptographic toolkit
        age # modern encryption tool
        sops # encrypted secret management
      ];
    };
}
