{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        foot                # Lightweight Wayland Terminal Emulator
        micro               # Terminal-based Text Editor
        superfile           # Terminal File Manager
        #nnn                # Ncurses-based File Browser
        ripgrep             # Regex Recursive Directory Search

        gh                  # GitHub CLI Tool
        wget                # Download Tool
        btop                # System Monitor
        fastfetch           # System Info
        mc                  # File Manager
        sops                # Managing Secrets Tool
        age                 # Modern encryption tool with small explicit keys
        ssh-to-age          # Convert SSH Private Keys (ed25519 format) to age keys

        pciutils            # PCI Device Utilities
        wlr-randr           # Manage monitor resolution, rotation, refresh rate, etc.
        lshw                # Detailed information on the hardware configuration
        glxinfo             # Test utilities for OpenGL
    ];
}