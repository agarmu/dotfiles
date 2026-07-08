{ inputs, ... }: {
  flake.modules.homeManager.gui = { pkgs, ... }: {
    imports = [ inputs.self.modules.homeManager.zotero ];
    programs.zotero = {
      enable = true;
      package = pkgs.zotero;
      addons = with pkgs.zotero-addons; [
        zotero-cita
        zotero-ocr
        zotero-better-notes
        zotero-better-bibtex
        scite-zotero-plugin
      ];
    };
  };
}
