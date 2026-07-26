{
  lib,
  fetchgit,
  buildGoModule,
}:
buildGoModule {
  pname = "stinkpot";
  version = "0.0.0-unstable-2026-07-20";
  src = fetchgit {
    url = "https://tangled.org/oppi.li/stinkpot";
    rev = "cdf87ffcd36e96f3d49316d57fa17cc6ea8371df";
    hash = "sha256-65QVLKVRGIPSCBYDemGqqOBXvMWxvo0ms65bCaw9Bfg=";
  };
  vendorHash = "sha256-iDlU/176inkilehXft25KjiLt7rUtlMGqod22A3O/ko=";
  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-w"
  ];
  meta = {
    description = "sqlite-backed shell history";
    homepage = "https://tangled.org/oppi.li/stinkpot";
    licenses = lib.licenses.unfree;
    mainProgram = "stinkpot";
    platforms = lib.platforms.unix;
  };
}
