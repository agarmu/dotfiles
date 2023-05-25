{ config, pkgs, ... }:
{
	programs.go = {
		enable = true;
	    packages = {    
	    # benchmarks to measure Go as it is developed.
		"golang.org/x/benchmarks" = builtins.fetchGit "https://go.googlesource.com/benchmarks";
	    # build.golang.org's implementation.
		"golang.org/x/build" = builtins.fetchGit "https://go.googlesource.com/build";
	    # additional cryptography packages.
		"golang.org/x/crypto" = builtins.fetchGit "https://go.googlesource.com/crypto";
	    # an experimental debugger for Go.
		"golang.org/x/debug" = builtins.fetchGit "https://go.googlesource.com/debug";
	    # experimental and deprecated packages (handle with care; may change without warning).
	    #    "golang.org/x/exp" = builtins.fetchGit "https://go.googlesource.com/exp";
	    # additional imaging packages.
		"golang.org/x/image" = builtins.fetchGit "https://go.googlesource.com/image";
	    # experimental support for Go on mobile platforms.
	    #    "golang.org/x/mobile" = builtins.fetchGit "https://go.googlesource.com/mobile";
	    # packages for writing tools that work with Go modules.
		"golang.org/x/mod" = builtins.fetchGit "https://go.googlesource.com/mod";
	    # additional networking packages.
		"golang.org/x/net" = builtins.fetchGit "https://go.googlesource.com/net";
	    # a client implementation for the OAuth 2.0 spec
		"golang.org/x/oauth2" = builtins.fetchGit "https://go.googlesource.com/oauth2";
	    # packages and tools for performance measurement, storage, and analysis.
		"golang.org/x/perf" = builtins.fetchGit "https://go.googlesource.com/perf";
	    # home of the pkg.go.dev website.
	    #    "golang.org/x/pkgsite" = builtins.fetchGit "https://go.googlesource.com/pkgsite";
	    # a tool for working with Gerrit code reviews.
	    #    "golang.org/x/review" = builtins.fetchGit "https://go.googlesource.com/review";
	    # additional concurrency primitives.
		"golang.org/x/sync" = builtins.fetchGit "https://go.googlesource.com/sync";
	    # packages for making system calls.
		"golang.org/x/sys" = builtins.fetchGit "https://go.googlesource.com/sys";
	    # Go terminal and console support packages.
		"golang.org/x/term" = builtins.fetchGit "https://go.googlesource.com/term";
	    # packages for working with text.
		"golang.org/x/text" = builtins.fetchGit "https://go.googlesource.com/text";
	    # additional time packages.
		"golang.org/x/time" = builtins.fetchGit "https://go.googlesource.com/time";
	    # godoc, goimports, gorename, and other tools.
	    #    "golang.org/x/tools" = builtins.fetchGit "https://go.googlesource.com/tools";
	    # tour.golang.org's implementation.
	    #    "golang.org/x/tour" = builtins.fetchGit "https://go.googlesource.com/tour";
	    # packages for accessing and analyzing data from the Go Vulnerability Database.
	    #    "golang.org/x/vuln" = builtins.fetchGit "https://go.googlesource.com/vuln";
	    # home of the go.dev and golang.org websites.
	    #    "golang.org/x/website" = builtins.fetchGit "https://go.googlesource.com/website";
	    };
	};
}