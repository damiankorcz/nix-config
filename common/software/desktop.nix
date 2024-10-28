{ config, pkgs, ... }:

{
    # ------------ Nixpkgs ------------

    environment.systemPackages = with pkgs; [
        # Applications
        mpv                                     # Video Player
        svp                                     # SmoothVideo Project 4 - Converts any video to 60 fps
        vscode                                  # Code Editor
        spotify                                 # Music Streaming
        discord                                 # Official Discord Client
        vesktop                                 # Discord (Alt Client)
        birdtray                                # Mail system tray notification icon for Thunderbird
        syncplay                                # Synchronise Media Players
        obsidian                                # Note Taking
        gearlever                               # AppImage Manager
        argyllcms                               # Colour Managment System
        ente-auth                               # 2FA
        displaycal                              # Display Calibration Tool
        trackma-qt                              # AniList Client
        microsoft-edge                          # Web Browser
        github-desktop                          # Github Client
        gimp-with-plugins                       # Image Manipulation Program
        simplescreenrecorder                    # Screen Recorder
        inkscape-with-extensions                # Vector Graphics Editor
        #libreoffice-qt6-fresh                  # Office Suite

        # Peripherals
        vial                                    # Keyboard Firmware Manager
        jamesdsp                                # Audio effect processor for PipeWire clients (EQ for Headphones)
        qpwgraph                                # Qt graph manager for PipeWire
        naps2                                   # Document Scanning
        corectrl                                # Profile based system control utility

        # KDE Applications (QT)
        krita                                   # Digital Painting
        digikam                                 # Photo Management Application
        krita-plugin-gmic                       # Image Processing Plugin
        kdePackages.kate                        # Text / Code Editor
        kdePackages.kalk                        # Calculator
        kdePackages.elisa                       # Music Player
        #kdePackages.kamoso                     # Webcam Utility (Marked as Broken)
        kdePackages.kclock                      # Clock
        #kdePackages.arianna                    # Epub Reader
        kdePackages.kweather                    # Weather
        # kdePackages.skanlite                  # Lite Image Scanning
        # kdePackages.skanpage                  # Multi-page Document Scanning
        kdePackages.filelight                   # Quickly visualize your disk space usage
        kdePackages.kde-gtk-config              # Syncs KDE settings to GTK applications
        kdePackages.partitionmanager            # Manage disks, partitions and file systems

        wineWowPackages.stagingFull             # Run Windows Apps on Linux
        winetricks                              # Script to install DLLs needed to work around problems in Wine

        # Vivaldi - Currently some dependancy issues require this to work
        # https://github.com/NixOS/nixpkgs/issues/309056
        # https://github.com/NixOS/nixpkgs/pull/292148
        (vivaldi.overrideAttrs (oldAttrs: {
            dontWrapQtApps = false;
            dontPatchELF = true;
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.kdePackages.wrapQtAppsHook ];
        }))
    ];

    # ------------ Excludes ------------

    services.xserver.excludePackages = [ pkgs.xterm ];

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/plasma6.nix#L135
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        #krdp            # Remove Desktop (RDP)
        khelpcenter     # Help app
        #konsole         # Terminal Emulator
    ];

    # ------------ Programs with Daemons ------------

    programs = {
        thunderbird.enable = true;      # Email Client
        coolercontrol.enable = true;    # Cooling Device Control
        gnupg.agent.enable = true;
        adb.enable = true;              # Android Debug Bridge (ADB)

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

        packages = [ ];
    };

    # ------------ AppImage ------------

    programs.appimage = {
        enable = true;
        binfmt = true;
    };
}
