{ pkgs, ... }:

{
    # ------------ Nixpkgs ------------
    
    environment.systemPackages = with pkgs; [
        # emulationstation-de # Frontend for browsing and launching games from your multi-platform game collection (Outdated - https://github.com/NixOS/nixpkgs/pull/299298)
        
        mame                # Arcade Games
        dosbox-staging      # DOS
        duckstation         # PlayStation 1 (Outdated - https://github.com/NixOS/nixpkgs/issues/335958)
        pcsx2               # PlayStation 2
        rpcs3               # PlayStation 3
        ppsspp-qt           # PlayStation Portable
        lime3ds             # Nintendo 3DS
        rmg-wayland         # Nintendo 64
        melonDS             # Nintendo DS
        sameboy             # Nintendo Game Boy & Game Boy Color
        mgba                # Nintendo Game Boy Advance
        dolphin-emu         # Nintendo GameCube & Wii
        #cemu               # Nintendo Wii U (Build currently broken)
        ryujinx             # Nintendo Switch
        punes-qt6           # Nintendo Entertainment System
        snes9x              # Super Nintendo Entertainment System
        blastem             # Sega Genesis / Megadrive
        flycast             # Sega Dreamcast, Naomi/2 and Atomiswave
        xemu                # Xbox
    ];
    
    # ------------ Flatpak ------------

    services.flatpak.packages = [
        "info.cemu.Cemu"    # Wii U
    ];

    # App Images
    # - PlayStation Vita = https://github.com/Vita3K/Vita3K/releases
    # - ES-DE = https://gitlab.com/es-de/emulationstation-de/-/packages/26318009
}