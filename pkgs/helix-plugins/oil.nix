{
  buildHelixPlugin,
  fetchFromGitHub,
  lib,
  notify,
}:
buildHelixPlugin {
  pname = "oil.hx";
  version = "0-unstable-2026-07-29";
  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = "oil.hx";
    rev = "fdd38520dc041d4314a7c5bc13520195b7f06cfa";
    hash = "sha256-cMpKLYVh5RkrbmKbigYdAjrF8J1wq6KxOfXoZ4AHLeE=";
  };
  pluginDependencies = [ notify ];
  meta = {
    description = "File manager in a buffer for Helix";
    homepage = "https://github.com/Ra77a3l3-jar/oil.hx";
    license = lib.licenses.mit;
  };
}
