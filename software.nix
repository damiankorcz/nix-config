  { config, pkgs, ... }:

{
    # ------------ Nixpkgs ------------

    environment.systemPackages = with pkgs; [
        # Software
        kdePackages.kate # Text / Code Editor
        vial # Keyboard Firmware Manager
        arandr # Monitor / Resolution Manager (X11)
        syncplay # Synchronise Media Players
        krita
        krita-plugin-gmic
        github-desktop
        # libsForQt5.xp-pen-deco-01-v2-driver # XP-Pen Driver and Software (works with many XP-Pen Tablets)

        # Terminal Utilities
        gh # GitHub CLI tool
        wget # Download tool
        btop # System Monitor
        fastfetch # System Info
        xorg.xrandr # Monitor / Resolution Manager (X11)
        home-manager
    ];

    # ------------ Flatpak ------------

    services.flatpak.enable = true;
    services.flatpak.update.auto = {
        enable = true;
        onCalendar = "weekly";
    };

    services.flatpak.packages = [
        # Software
        "com.visualstudio.code"
        "org.mozilla.Thunderbird"
        "com.ulduzsoft.Birdtray" # Tray icon for Thunderbird
        "com.bitwarden.desktop" # Password Manager
        "org.mozilla.firefox"
        "com.microsoft.Edge"
        "md.obsidian.Obsidian"
        "com.spotify.Client"
        "com.discordapp.Discord"
        "com.github.johnfactotum.Foliate" # EBook Reader
        "info.febvre.Komikku" # Manga / Comics Reader
        "io.mpv.Mpv" # Video Player
        "io.missioncenter.MissionCenter" # System Stats
        "org.libreoffice.LibreOffice" # Office Suite
        # "io.github.shiftey.Desktop" # GitHub Desktop client
        "dev.zed.Zed" # Text / Code Editor
        "com.github.tchx84.Flatseal" # Flatpak Permissions Manager
        "it.mijorus.gearlever" # AppImage Manager
        "org.inkscape.Inkscape" # Vector Graphics Editor

        # Emulators
        "io.mgba.mGBA" # Game Boy Advance
        "org.ppsspp.PPSSPP" # PlayStation Portable
        "com.snes9x.Snes9x" # Super Nintendo Entertainment System
        "org.flycast.Flycast" # Sega Dreamcast, Naomi/2 and Atomiswave
        "io.github.sameboy.SameBoy" # Game Boy & Game Boy Color
        "org.ryujinx.Ryujinx" # Nintendo Switch
        "io.github.dosbox-staging" # DOS
        "app.xemu.xemu" # OG Xbox
        "org.duckstation.DuckStation" # PlayStation 1
        "net.rpcs3.RPCS3" # PlayStation 3
        "io.github.simple64.simple64" # Nintendo 64
        "info.cemu.Cemu" # Wii U
        "io.github.lime3ds.Lime3DS" # Nintendo 3DS
        "org.DolphinEmu.dolphin-emu" # GameCube & Wii
        "net.pcsx2.PCSX2" # PlayStation 2
        "net.kuribo64.melonDS" # Nintendo DS
        "org.mamedev.MAME" # Arcade games
    ];

    # ------------ AppImage ------------

    programs.appimage = {
        enable = true;
        binfmt = true;
    };

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

    # ------------ Plasma Excludes ------------
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/plasma6.nix#L135
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        khelpcenter # Help app
        krdp # Remove Desktop (RDP)
    ];

    # ------------ Other ------------

#   programs.steam = {
#     # Some location that should be persistent:
#     #   ~/.local/share/Steam - The default Steam install location
#     #   ~/.local/share/Steam/steamapps/common - The default Game install location
#     #   ~/.steam/root        - A symlink to ~/.local/share/Steam
#     #   ~/.steam             - Some Symlinks & user info
#     enable = true;
#     remotePlay.openFirewall = true;
#     dedicatedServer.openFirewall = true;
#     gamescopeSession.enable = true;
#   }

}
