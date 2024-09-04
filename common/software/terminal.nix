{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        gh                  # GitHub CLI Tool
        wget                # Download Tool
        btop                # System Monitor
        fastfetch           # System Info
        mc                  # File Manager
        age                 # Modern encryption tool with small explicit keys

        pciutils            # PCI Device Utilities
        wlr-randr           # Manage monitor resolution, rotation, refresh rate, etc.
        lshw                # Detailed information on the hardware configuration
        glxinfo             # Test utilities for OpenGL
    ];
}