{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        # Terminal App Alternatives
        micro               # Terminal-based Text Editor
        nnn                 # Ncurses-based File Browser
        ripgrep             # Regex Recursive Directory Search
        gh                  # GitHub CLI Tool
        wget                # Download Tool
        btop                # System Monitor
        fastfetch           # System Info
        mc                  # File Manager
        unrar               # Utility for RAR archives
        imagemagick         # Image Manipulation Tool
        atuin               # Shell History Replacement

        nixpkgs-review      # Review pull-requests on https://github.com/NixOS/nixpkgs

        # Secret / Keys
        sops                # Managing Secrets Tool
        age                 # Modern encryption tool with small explicit keys
        ssh-to-age          # Convert SSH Private Keys (ed25519 format) to age keys

        # GPU Tools
        pciutils            # PCI Device Utilities
        lshw                # Hardware Configuration Info
        glxinfo             # Test utilities for OpenGL
        wmctrl              # X WM Interaction Tool
        xdotool             # Fake keyboard/mouse input, window management and more
        xautomation         # Control X from the command line for scripts, and do "visual scraping" to find things on the screen
    ];

    programs = {
        bash.blesh.enable = true; # Full-featured line editor written in pure Bash
    };
}