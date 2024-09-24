{ config, pkgs, ... }:

{
    # ------------ Nixpkgs ------------

    environment.systemPackages = with pkgs; [
        # Applications
        mpv                                     # Video Player
        svp                                     # SmoothVideo Project 4 - Converts any video to 60 fps
        #mpvScripts.modernx-zydezu              # Modern OSC UI for MPV
        pinta                                   # Drawing/editing program modeled after Paint.NET
        vscode                                  # Code Editor
        ocs-url                                 # DE Store Website Integration
        #firefox                                # Web Browser
        bottles                                 # Easy-to-use Wineprefix Manager
        spotify                                 # Music Streaming
        vesktop                                 # Discord (Alt Client)
        wezterm                                 # GPU Accelerated Terminal Emulator
        foliate                                 # Ebook Reader
        komikku                                 # Manga / Comic Reader
        birdtray                                # Mail system tray notification icon for Thunderbird
        syncplay                                # Synchronise Media Players
        obsidian                                # Note Taking
        gearlever                               # AppImage Manager
        argyllcms                               # Colour Managment System
        displaycal                              # Display Calibration Tool
        trackma-qt                              # AniList Client
        microsoft-edge                          # Web Browser
        github-desktop                          # Github Client
        bitwarden-desktop                       # Password Manager
        gimp-with-plugins                       # Image Manipulation Program
        inkscape-with-extensions                # Vector Graphics Editor
        #libreoffice-qt6-fresh                  # Office Suite

        # Peripherals
        vial                                    # Keyboard Firmware Manager
        jamesdsp                                # Audio effect processor for PipeWire clients (EQ for Headphones)
        naps2                                   # Document Scanning

        # KDE Applications (QT)
        krita                                   # Digital Painting
        krita-plugin-gmic                       # Image Processing Plugin
        kdePackages.kate                        # Text / Code Editor
        kdePackages.kalk                        # Calculator
        kdePackages.elisa                       # Music Player
        #kdePackages.kamoso                     # Webcam Utility (Marked as Broken)
        kdePackages.kclock                      # Clock
        kdePackages.arianna                     # Epub Reader
        kdePackages.kweather                    # Weather
        kdePackages.skanlite                    # Lite Image Scanning
        kdePackages.skanpage                    # Multi-page Document Scanning
        kdePackages.filelight                   # Quickly visualize your disk space usage
        kdePackages.kde-gtk-config              # Syncs KDE settings to GTK applications
        kdePackages.partitionmanager            # Manage disks, partitions and file systems

        wineWowPackages.stagingFull # Run Windows Apps on Linux
        winetricks                  # Script to install DLLs needed to work around problems in Wine

        # aspell                                  # Spell checker
        # aspellDicts.en                          # Dictionary for English
        # aspellDicts.en-science                  # Dictionary for English Scientific Jargon
        # aspellDicts.en-computers                # Dictionary for English Computer Jargon
        # aspellDicts.pl                          # Dictionary for Polish
    ];

    services.xserver.excludePackages = [ pkgs.xterm ];

    # Plasma Excludes
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/plasma6.nix#L135
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        krdp            # Remove Desktop (RDP)
        khelpcenter     # Help app
        konsole         # Terminal Emulator
    ];

    # Programs with Daemons
    programs = {
        thunderbird.enable = true;      # Email Client
        coolercontrol.enable = true;    # Cooling Device Control
        gnupg.agent.enable = true;
        adb.enable = true;              # Android Debug Bridge (ADB)
        
        # Hardware control / monitoring and overclocking program
        tuxclocker = {
            enable = true;
            #enabledNVIDIADevices
            enableAMD = true;
            useUnfree = true;
        };

        #home-manager.enable = true;    # Nix User Environment Configurator
        #nix-ld.enable  = true;         # TEMP
    };

    # ------------ Flatpak ------------

    services.flatpak = {
        enable = true;
        update.auto = {
            enable = true;
            onCalendar = "weekly";
        };

        packages = [ 
            "com.vivaldi.Vivaldi"   # Web Browser (Issues with packaging in nix)
        ];
    };

    # ------------ AppImage ------------

    programs.appimage = {
        enable = true;
        binfmt = true;
    };
}
