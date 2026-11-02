{
  writeShellApplication,
  lib,
  nushell,
  ghostscript,
  qpdf,
  coreutils,
}:
writeShellApplication {
  name = "slideconv";
  runtimeInputs = [
    nushell
    ghostscript
    qpdf
    coreutils
  ];
  text = ''
    exec ${lib.getExe nushell} ${./slideconv.nu} "$@"
  '';
  meta = {
    description = "Export course PowerPoint slides to trimmed PDFs";
    platforms = lib.platforms.darwin;
  };
}
