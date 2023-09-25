{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    coreutils
    eza
    ffmpeg
    htop
    jq
    mold
    rustup
    wget
    wget2
  ];
}
