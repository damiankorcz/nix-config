  { config, pkgs, ... }:

{
    # ------------ Nixpkgs ------------

    environment.systemPackages = with pkgs; [
        # Applications
        mpv                         # Video Player
        mpvScripts.modernx-zydezu   # Modern OSC UI for MPV
        vscode                      # Code Editor
        bottles                     # Easy-to-use Wineprefix Manager
        spotify                     # Music Streaming
        vesktop                     # Discord (Alt Client)
        foliate                     # Ebook Reader
        komikku                     # Manga / Comic Reader
        syncplay                    # Synchronise Media Players
        obsidian                    # Note Taking
        birdtray                    # Tray Icon for Thunderbird
        gearlever                   # AppImage Manager
        argyllcms                   # Colour Managment System
        displaycal                  # Display Calibration Tool
        microsoft-edge              # Web Browser
        mission-center              # System Monitor
        github-desktop              # Github Client
        bitwarden-desktop           # Password Manager
        libreoffice-qt6-fresh       # Office Suite
        inkscape-with-extensions    # Vector Graphics Editor

        samba
        cifs-utils

        # Peripherals
        vial                                # Keyboard Firmware Manager
        pipewire                            # Frontend for ratbagd (Gaming Mouse Configuration Library)
        #libForQt5.xo-pen-deco-01-v2-driver # XP Pen Driver and Software (works with many XP-Pen Tablets)

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
        kdePackages.plasma-browser-integration  # Browser Integration in Plasma Desktop

        # Gaming
        mangohud    # Vulkan / OpenGL Overlay for System Monitoring and FPS
        lutris      # Open Source Gaming Platform
        protonup-qt # Install / Manager Proton-GE & Luxtorpeda for Steam / Wine-GE for Lutris

        # Emulators
        mame            # Arcade Games
        dosbox-staging  # DOS
        duckstation     # PlayStation 1 (Outdated - https://github.com/NixOS/nixpkgs/issues/335958)
        pcsx2           # PlayStation 2 (Outdated - https://github.com/NixOS/nixpkgs/issues/335956)
        rpcs3           # PlayStation 3
        ppsspp-qt       # PlayStation Portable
        lime3ds         # Nintendo 3DS
        rmg-wayland     # Nintendo 64
        melonDS         # Nintendo DS
        sameboy         # Nintendo Game Boy & Game Boy Color
        mgba            # Nintendo Game Boy Advance
        dolphin-emu     # Nintendo GameCube & Wii
        #cemu           # Nintendo Wii U (Build currently broken)
        ryujinx         # Nintendo Switch
        punes-qt6       # Nintendo Entertainment System
        snes9x          # Super Nintendo Entertainment System
        blastem         # Sega Genesis / Megadrive (Outdated - https://github.com/NixOS/nixpkgs/issues/335953)
        flycast         # Sega Dreamcast, Naomi/2 and Atomiswave
        xemu            # Xbox

        # Terminal Utilities
        gh              # GitHub CLI Tool
        wget            # Download Tool
        btop            # System Monitor
        pciutils        # PCI Device Utilities
        libnotify       # Library for Sending Desktop Notifications to the Notification Daemon
        fastfetch       # System Info
        home-manager    # Nix-based User Environment Configurator
    ];

    # Plasma Excludes
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/plasma6.nix#L135
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        khelpcenter # Help app
        krdp # Remove Desktop (RDP)
    ];

    # Programs with Daemons
    # Cooling device control
    programs = {
        coolercontrol.enable = true;
        thunderbird.enable = true;
    };

    # ------------ Flatpak ------------

    services.flatpak.enable = true;
    services.flatpak.update.auto = {
        enable = true;
        onCalendar = "weekly";
    };

    services.flatpak.packages = [
        "info.cemu.Cemu" # Wii U
    ];

    # ------------ AppImage ------------

    programs.appimage = {
        enable = true;
        binfmt = true;
    };

    # PlayStation Vita = https://github.com/Vita3K/Vita3K/releases

    # ------------ Fonts ------------

    fonts = {
        # use fonts specified by user rather than default ones
        # enableDefaultPackages = false;

        fontDir.enable = true; # Links all fonts to: `/run/current-system/sw/share/X11/font`

        packages = with pkgs; [
            font-awesome
            noto-fonts
            noto-fonts-emoji
            source-sans
            source-serif
            corefonts
            vistafonts

            # Nerdfonts
            # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
            (nerdfonts.override {
                fonts = [
                    # symbols icon only
                    "NerdFontsSymbolsOnly"

                    # Characters
                    "CascadiaCode"
                    "FiraCode"
                    "GeistMono"
                    "IBMPlexMono"
                    "Iosevka"
                    "JetBrainsMono"
                    "SourceCodePro"
                    "UbuntuMono"
                ];
            })
        ];
    };

    # ------------ Other ------------

    programs.steam = {
        # Some location that should be persistent:
        #   ~/.local/share/Steam - The default Steam install location
        #   ~/.local/share/Steam/steamapps/common - The default Game install location
        #   ~/.steam/root        - A symlink to ~/.local/share/Steam
        #   ~/.steam             - Some Symlinks & user info
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
    };
}
