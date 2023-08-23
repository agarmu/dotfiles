{ config, pkgs, ... }:
{
	homebrew = {
	    enable = true;
	    taps = [
		"homebrew/cask"
	    ];
	    brews = [
              "openjdk"
            ];
	    casks = [
		"thunderbird"
		"anaconda"
		"adobe-acrobat-pro"
		"anki"
		"calibre"
		"docker"
		"eagle"
		"hammerspoon"
		"inkscape" "gimp"
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
		"vlc"
		"xournal-plus-plus"
		"zoom"
		"zotero"
		"anaconda"
              ];

	    masApps = {
		"GeoGebra Calculator Suite" = 1504416652;
		"Microsoft OneNote" = 784801555;
		"Microsoft Excel" = 462058435;
		"Slack" = 803453959;
		"Microsoft Outlook" = 985367838;
		"WhatsApp" = 1147396723;
		"Microsoft Word" = 462054704;
		"Pages" = 409201541;
		"Microsoft PowerPoint" = 462062816;
	    };
	};
}
