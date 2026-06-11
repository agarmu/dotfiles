{
  flake.modules.homeManager.gui = {
    programs.firefox.profiles.dev-edition-default.search = {
      force = true;
      default = "google";
      privateDefault = "ddg";
      order = [
        "google"
        "ddg"
        "wikipedia"
      ];
      engines = {
        nwiki = {
          name = "NixOS Wiki";
          urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
        };
        bing.metaData.hidden = true;
      };
    };
  };
}
