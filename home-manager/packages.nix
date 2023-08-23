{ config, pkgs, ... }:
{
# Packages that should be installed to the user profile.
	home.packages = with pkgs; [
	    aria
	    delta
	    discord
	    docker
	    cmake
	    cmatrix
	    commitizen
	    fd
	    flyctl
	    fswatch
	    gcc12
	    gnumake
	    lazygit
	    ninja
	    meson
	    gnumake 
	    heroku
	    hyperfine
	    # julia
	    neofetch
	    nnn
	    hyfetch
	    imagemagick
	    pdftk
	    ripgrep
	    socat
	    # spotifyd
	    spicetify-cli
	    spotify-tui
	    yt-dlp
	    zathura
	    zoom-us
	    texlive.combined.scheme-full
	    teams
		wasm-pack
	];
}
