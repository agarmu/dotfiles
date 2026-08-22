{
  buildFirefoxXpiAddon,
  fetchurl,
  nix-update-script,
  lib,
  ...
}:

buildFirefoxXpiAddon rec {
  pname = "hister";
  version = "0.28.0";
  addonId = "{f0bda7ce-0cda-42dc-9ea8-126b20fed280}";
  src = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4934117/hister-0.28.0.xpi";
    hash = "sha256-PIXN+9Mt0AsKWUU6WgFa127UsOonB5y62hrtkuSesOM=";
  };
  meta = with lib; {
    homepage = "https://addons.mozilla.org/en-US/firefox/addon/hister/";
    description = "Web history on steroids.";
    license = licenses.agpl3Only;
    mozPermissions = [
      "tabs"
      "storage"
      "cookies"
      "<all_urls>"
    ];
    platforms = platforms.all;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "firefox-addons.hister";
    extraArgs = [
      "--version=branch"
      "--flake"
    ];
  };
}
