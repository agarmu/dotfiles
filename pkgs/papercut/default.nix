{
  firefox,
  lib,
  openssh,
  python3,
  stdenvNoCC,
}:
let
  firefoxPackage = firefox.override {
    extraPolicies = {
      DontCheckDefaultBrowser = true;
      NewTabPage = false;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      SkipTermsOfUse = true;
    };
  };
  firefoxExe =
    if stdenvNoCC.hostPlatform.isDarwin then
      "${firefoxPackage}/Applications/Firefox.app/Contents/MacOS/firefox"
    else
      "${firefoxPackage}/bin/firefox";
in
stdenvNoCC.mkDerivation {
  pname = "papercut";
  version = "0";

  dontUnpack = true;
  strictDeps = true;

  buildInputs = [
    firefoxPackage
    openssh
    python3
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 ${./papercut.py} $out/bin/papercut
    substituteInPlace $out/bin/papercut \
      --replace-fail '@firefox@' '${firefoxExe}' \
      --replace-fail '@ssh@' '${lib.getExe openssh}'
    runHook postInstall
  '';

  meta = {
    description = "Open Purdue PaperCut through an SSH SOCKS proxy";
    license = lib.licenses.mit;
    mainProgram = "papercut";
    platforms = lib.platforms.unix;
  };
}
