{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
}:
buildHelixPlugin {
  pname = "glyph.hx";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = "glyph.hx";
    tag = "0.2.0";
    hash = "sha256-TpYnGqROkKfoB9G+JTjADWvMtpRJbv4NVaTqiUfW1Eg=";
  };
  meta = {
    description = "Shared icon library for Helix plugins";
    homepage = "https://github.com/Ra77a3l3-jar/glyph.hx";
    license = lib.licenses.mit;
  };
}
