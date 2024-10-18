{ pkgs, userSettings, ... }:

{
    # ------------ Nixpkgs ------------
    
    environment.systemPackages = with pkgs; [
        # emulationstation-de # Emulation Frontend (Outdated - https://github.com/NixOS/nixpkgs/pull/299298)
        
        mame                # Arcade Games

        dosbox-staging      # DOS
        dosbox-x            # DOS

        duckstation         # PlayStation 1 (Outdated - https://github.com/NixOS/nixpkgs/issues/335958)
        pcsx2               # PlayStation 2
        rpcs3               # PlayStation 3
        ppsspp-qt           # PlayStation Portable

        #lime3ds            # Nintendo 3DS
        rmg                 # Nintendo 64
        melonDS             # Nintendo DS
        fceux               # Nintendo Entertainment System
        sameboy             # Nintendo Game Boy & Game Boy Color
        mgba                # Nintendo Game Boy Advance
        dolphin-emu         # Nintendo GameCube & Wii
        cemu                # Nintendo Wii U
        ryujinx             # Nintendo Switch
        snes9x-gtk          # Super Nintendo Entertainment System

        blastem             # Sega Genesis / Megadrive
        flycast             # Sega Dreamcast, Naomi/2 and Atomiswave
        mednafen            # Sega Saturn (Many others supported)
        mednaffe            # GTK-based frontend for mednafen emulator

        xemu                # Xbox

        
        # X11
        #switchres          # Modeline generation engine for emulation (X11 only)
        #wmctrl              # X WM Interaction Tool
        #xdotool             # Fake keyboard / mouse input, window management and more
        #xautomation         # Control X from the command line for scripts, and do "visual scraping" to find things on the screen

        # Wayland
        kdotool             # xdotool-like for KDE Wayland
    ];

    # Generic Linux command-line automation tool (keyboard / mouse input)
    programs.ydotool.enable = true;
    users.users.${userSettings.username}.extraGroups = [ "ydotool" ];
    
    # ------------ Flatpak ------------

    services.flatpak.packages = [ ];

    # App Images
    # - PlayStation Vita = https://github.com/Vita3K/Vita3K/releases
    # - ES-DE = https://gitlab.com/es-de/emulationstation-de/-/packages/26318009
}
