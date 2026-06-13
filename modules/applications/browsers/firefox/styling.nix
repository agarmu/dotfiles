{
  flake.modules.homeManager.gui = {
    stylix.targets.firefox = {
      enable = false;
      firefoxGnomeTheme.enable = false;
    };
    programs.firefox.profiles.default = {
      settings = {
        # basic styling
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.nova.enabled" = false;
        "browser.tabs.allow_transparent_browser" = true;

        # homepage
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
      };
    };
  };
}
