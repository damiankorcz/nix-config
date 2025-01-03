{ pkgs, ... }:

{
    # ------------ Nixpkgs ------------

    environment.systemPackages = with pkgs; [
        # Applications
        mpv                                     # Video Player
        brave                                   # Web Browser
        firefox                                  # Web Browser
        spotify                                 # Music Streaming
        syncplay                                # Synchronise Media Players
        obsidian                                # Note Taking
        gearlever                               # AppImage Manager
        argyllcms                               # Colour Managment System
        ente-auth                               # 2FA
        displaycal                              # Display Calibration Tool
        trackma-qt                              # AniList Client
        microsoft-edge                          # Web Browser
        github-desktop                          # Github Client
        #gimp-with-plugins                       # Image Manipulation Program
        simplescreenrecorder                    # Screen Recorder
        inkscape-with-extensions                # Vector Graphics Editor
        libreoffice-qt6-fresh                  # Office Suite

        # Peripherals
        qmk                                     # Keyboard Firmware
        vial                                    # Keyboard Firmware Manager
        dfu-util                                 # USB Programmer
        jamesdsp                                # Audio effect processor for PipeWire clients (EQ for Headphones)
        qpwgraph                                # Qt graph manager for PipeWire
        #naps2                                   # Document Scanning / ISSUE: https://github.com/NixOS/nixpkgs/issues/326335

        # KDE Applications (QT)
        krita                                   # Digital Painting
        krita-plugin-gmic                       # Image Processing Plugin
        kdePackages.kate                        # Text / Code Editor
        kdePackages.kalk                        # Calculator
        kdePackages.elisa                       # Music Player
        kdePackages.kclock                      # Clock
        kdePackages.kweather                    # Weather
        kdePackages.filelight                   # Quickly visualize your disk space usage
        kdePackages.kde-gtk-config              # Syncs KDE settings to GTK applications
        kdePackages.partitionmanager            # Manage disks, partitions and file systems
        #kdePackages.kleopatra

        wineWowPackages.stagingFull             # Run Windows Apps on Linux
        winetricks                              # Script to install DLLs needed to work around problems in Wine
    ];

    # ------------ Excludes ------------

    services.xserver.excludePackages = [ pkgs.xterm ];

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/plasma6.nix#L135
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        khelpcenter     # Help app
        krdp            # Remove Desktop (RDP)
        discover        # Software Store
    ];

    # ------------ Programs with Daemons ------------

    programs = {
        kde-pim.enable = false;         # Used for Kontact / Kmail
        coolercontrol.enable = true;    # Cooling Device Control
        gnupg.agent.enable = true;
        adb.enable = true;              # Android Debug Bridge (ADB)
    };

    # ------------ Flatpak ------------

    services.flatpak = {
        enable = true;
        update.auto = {
            enable = true;
            onCalendar = "weekly";
        };

        remotes = [
            { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
            { name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo"; }
        ];

        packages = [ 
            { appId = "com.discordapp.DiscordCanary"; origin = "flathub-beta";  }
            "com.discordapp.Discord" # Requires XDG_SESSION_TYPE=x11 for screensharing to work.
            "dev.vencord.Vesktop"
            "eu.betterbird.Betterbird" # Imporved client for Thunderbird. Removed from nixpkgs due to lack of maintainers
        ];
    };

    # ------------ AppImage ------------

    programs.appimage = {
        enable = true;
        binfmt = true;
    };
}
