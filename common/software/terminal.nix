{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        # General Apps
        micro               # Terminal-based Text Editor
        lazygit             # Simple terminal UI for git commands
        mc                  # File Manager
        #atuin              # Shell History Replacement
        #nnn                # Ncurses-based File Browser
        #gh                 # GitHub CLI Tool

        # Development Dependencies
        pnpm                # Fast, disk space efficient package manager for JavaScript
        nodejs_20           # JavaScript runtime environment (20 is latest compatible with pnpm)
        python313           # Python 3.13
        nixd                # Nix language server

        # Terminal Tool Alternatives
        ripgrep             # 'grep' Alternative
        bat                 # 'cat' Alternative
        fd                  # 'find' Alternative
        eza                 # 'ls' Alternative

        # Monitoring / Stats
        fastfetch           # System Info
        lm_sensors          # Reading hardware sensors
        nvtopPackages.full  # Task monitor for GPUs and accelerators
        radeontop           # Task monitor for GPUs and accelerators for AMD Radeon
        btop                # System Monitor
        speedtest-go        # Internet Speed Test (speedtest.net)

        # Benchmark / Stress Test
        stress-ng

        # General Utilities
        thefuck             # Corrects your previous console command
        tlrc                # Official tldr client written in Rust
        imagemagick         # Image Manipulation Tool
        unrar               # Utility for RAR archives
        nixpkgs-review      # Review pull-requests on https://github.com/NixOS/nixpkgs
        xorg.xlsclients     # See which apps are running under xwayland

        # Secret / Keys
        sops                # Managing Secrets Tool
        age                 # Modern encryption tool with small explicit keys
        ssh-to-age          # Convert SSH Private Keys (ed25519 format) to age keys

        # GPU Tools
        pciutils           # PCI Device Utilities
        lshw               # Hardware Configuration Info
        glxinfo            # Test utilities for OpenGL
    ];
}