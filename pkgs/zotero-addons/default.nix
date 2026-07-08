{ callPackage }: {
  zotero-better-bibtex = callPackage ./zotero-better-bibtex.nix { };
  zotero-better-notes = callPackage ./zotero-better-notes.nix { };
  zotero-cita = callPackage ./zotero-cita.nix { };
  zotero-ocr = callPackage ./zotero-ocr.nix { };
  scite-zotero-plugin = callPackage ./scite-zotero-plugin.nix { };
}
