{ callPackage }: {
  zotero-cita = callPackage ./zotero-cita.nix { };
  zotero-ocr = callPackage ./zotero-ocr.nix { };
}
