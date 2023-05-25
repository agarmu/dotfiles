{ config, pkgs, ... }:
let draculatheme = builtins.fetchurl {
	url = "https://raw.githubusercontent.com/alacritty/alacritty-theme/0ea6ab87fed0d71dc9658dea95debc4124984607/themes/dracula.yaml";
	sha256 = "0f3w58i8kmi4y3i97jxz9bfwvnbqy54x1cscyx4ziygvwihsdm8s";
};
in
{
	programs.alacritty = {
		enable = true;
	    settings = {
		env.TERM = "alacritty";
		import = [
		    draculatheme
		];
		window = {
		    dimensions = {
		        lines = 35;
		        columns = 100;
		    };
		    padding = {
		        x = 0;
		        y = 0;
		    };
		    dynamic_padding = false;
		    decorations = "full";
		    startup_mode = "windowed";
		    opacity = 0.95;
		};
		scrolling = {
		    history = 1000;
		    multiplier = 5;
		};
		font = {
		    normal = {
		        family = "Hack Nerd Font Mono";
		        style = "Regular";
		    };
		    bold = {
		        family = "Hack Nerd Font Mono";
		        style = "Bold";
		    };
		    italic = {
		        family = "Hack Nerd Font Mono";
		        style = "Italic";
		    };
		    bold_italic = {
		        family = "Hack Nerd Font Mono";
		        style = "Bold Italic";
		    };
		    size = 12.0;
		    builtin_box_drawing = true;
		};
		cursor = {
		    style = "Block";
		    blinking = "On";
		};
	    };
	};
}
