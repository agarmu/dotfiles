{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
  glyph,
  notify,
}:
buildHelixPlugin {
  pname = "forest.hx";
  version = "0-unstable-2026-08-02";
  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = "forest.hx";
    rev = "c487956a8f002813fe44ae2a30fffe1859fcc206";
    hash = "sha256-b3O7+R5F9TQ0F5m8FYe6ka8mgCLq3IGw4d1Kdh+Y1l0=";
  };
  pluginDependencies = [
    glyph
    notify
  ];
  meta = {
    description = "A file explorer tree for Helix";
    homepage = "https://github.com/Ra77a3l3-jar/forest.hx";
    license = lib.licenses.mit;
  };
}
