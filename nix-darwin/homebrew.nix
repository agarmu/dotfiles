{ config, pkgs, ... }:
{
    homebrew = {
        enable = true;
        taps = [
            "homebrew/cask"
        ];
        casks = [
            "anaconda"
            "adobe-acrobat-pro"
            "anki"
            "calibre"
            "firefox"
            "firefox-developer-edition"
            "eagle"
            "hammerspoon"
            "inkscape"
            "insomnia"
            "logseq"
            "maccy"
            "mochi"
            "qbittorrent"
            "raspberry-pi-imager"
            "signal"
            "skim"
            "spotify"
            "veracrypt"
            "visual-studio-code"
            "vlc"
            "xournal-plus-plus"
            "zoom"
            "zotero"
        ];
        masApps = {
            "GeoGebra Calculator Suite" = 1504416652;
            "Xcode" = 497799835;
            "Microsoft OneNote" = 784801555;
            "Microsoft Excel" = 462058435;
            "Sigma Planner" = 1106938042;
            "Slack" = 803453959;
            "Microsoft Outlook" = 985367838;
            "WhatsApp" = 1147396723;
            "Microsoft Word" = 462054704;
            "Hotspot Shield" = 771076721;
            "Bitwarden" = 1352778147;
            "Pages" = 409201541;
            "Microsoft PowerPoint" = 462062816;
        };
    };
}