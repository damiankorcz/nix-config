{ config, pkgs, userSettings, ... }:

{
    # System Name / Host name
    networking.hostName = "nixos-desktop";

    # Fixing time sync when dualbooting with Windows
    time.hardwareClockInLocalTime = true;

    services = {
        displayManager = {
            # Enable automatic login for the user.
            autoLogin.enable = true;
            autoLogin.user = userSettings.username;

            # Declares default session (Wayland = plasma / X11 = plasmax11)
            defaultSession = "plasma";

            # Enable Display Manager for Plasma.
            sddm = {
                enable = true;
                wayland.enable = true;
            };
        };

        # Enable the KDE Plasma Desktop Environment.
        desktopManager.plasma6.enable = true;

        # Enable the X11 windowing system.
        # You can disable this if you're only using the Wayland session.
        # xserver.enable = true;

        # Configure keymap in X11
        xserver.xkb = {
            layout = "us";
            variant = "";
        };

        # Gaming Mouse Configuration Library
        ratbagd.enable = true;

        # Duplicati
        duplicati.enable = true;
        # duplicati.port = 8200; # Default 8200
    };

    # pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
    # pkgs.linuxPackages_latest; # Latest Stable
    # pkgs.linuxPackages; # LTS
    boot.kernelPackages = pkgs.linuxPackages_cachyos; # https://github.com/chaotic-cx/nyx
    
    chaotic.scx = {
        enable = true;

        # https://github.com/chaotic-cx/nyx/blob/935a1f5935853e5b57f1a9432457d8bea4dbb7d7/modules/nixos/scx.nix#L15
        # "scx_bpfland"
        scheduler = "scx_lavd";
    };
}
