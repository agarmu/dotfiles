{
  config,
  pkgs,
  ...
}: {
  security = {
    pam.enableSudoTouchIdAuth = true;
    pki.caCertificateBlacklist = [];
  };
}
