{ config, pkgs, ... }:

{
    # ------------ Nixpkgs ------------

    environment.systemPackages = with pkgs; [
        # Applications
        mpv                                     # Video Player
        mpvScripts.modernx-zydezu               # Modern OSC UI for MPV
        arandr                                  # Frontend for XRandR
        vscode                                  # Code Editor
        firefox                                 # Web Browser
        bottles                                 # Easy-to-use Wineprefix Manager
        spotify                                 # Music Streaming
        vesktop                                 # Discord (Alt Client)
        foliate                                 # Ebook Reader
        komikku                                 # Manga / Comic Reader
        syncplay                                # Synchronise Media Players
        obsidian                                # Note Taking
        birdtray                                # Tray Icon for Thunderbird
        gearlever                               # AppImage Manager
        timeshift                               # BTRFS Snapshots / System Restore Tool
        lan-mouse                               # Software KVM switch via the network
        argyllcms                               # Colour Managment System
        displaycal                              # Display Calibration Tool
        microsoft-edge                          # Web Browser
        mission-center                          # System Monitor
        github-desktop                          # Github Client
        bitwarden-desktop                       # Password Manager
        libreoffice-qt6-fresh                   # Office Suite
        inkscape-with-extensions                # Vector Graphics Editor

        # Peripherals
        vial                                    # Keyboard Firmware Manager
        piper                                   # Frontend for ratbagd (Gaming Mouse Configuration Library)
        jamesdsp                                # Audio effect processor for PipeWire clients (EQ for Headphones)
        #libForQt5.xo-pen-deco-01-v2-driver     # XP Pen Driver and Software (works with many XP-Pen Tablets)

        wineWowPackages.stagingFull             # Run Windows Apps on Linux
        winetricks                              # Script to install DLLs needed to work around problems in Wine

        # KDE Applications (QT)
        haruna                                  # Video Player
        krita                                   # Digital Painting
        krita-plugin-gmic                       # Image Processing Plugin
        kdePackages.kate                        # Text / Code Editor
        kdePackages.kalk                        # Calculator
        kdePackages.kclock                      # Clock
        kdePackages.kweather                    # Weather
        kdePackages.skanlite                    # Lite Image Scanning
        kdePackages.skanpage                    # Multi-page Document Scanning
        kdePackages.plasma-browser-integration  # Browser Integration in Plasma

        # Spellchecker
        hunspell                                # Spell checker
        hunspellDicts.pl_PL                     # Dictionary for Polish
        hunspellDicts.en_GB-large               # Dictionary for British English

        aspell                                  # Spell checker
        aspellDicts.en                          # Dictionary for English
        aspellDicts.en-science                  # Dictionary for English Scientific Jargon
        aspellDicts.en-computers                # Dictionary for English Computer Jargon
        aspellDicts.pl                          # Dictionary for Polish
    ];

    # Plasma Excludes
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/plasma6.nix#L135
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        krdp            # Remove Desktop (RDP)
        khelpcenter     # Help app
        #konsole
    ];

    # Programs with Daemons
    programs = {
        thunderbird.enable = true;      # Email Client
        coolercontrol.enable = true;    # Cooling Device Control
        gnupg.agent.enable = true;
        kde-pim.kmail = true;           # Email Client
        adb.enable = true;              # Android Debug Bridge (ADB)
        
        #home-manager.enable = true;    # Nix User Environment Configurator
        #nix-ld.enable  = true;         # TEMP
    };

    # ------------ Flatpak ------------

    services.flatpak.enable = true;
    services.flatpak.update.auto = {
        enable = true;
        onCalendar = "weekly";
    };

    # ------------ AppImage ------------

    programs.appimage = {
        enable = true;
        binfmt = true;
    };
}
