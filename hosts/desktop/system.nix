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
            defaultSession = "plasmax11";

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
        xserver.enable = true;

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

    # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
    boot.kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
    # boot.kernelPackages = pkgs.linuxPackages; # LTS
    
    #boot.kernelPackages = pkgs.linuxPackages_cachyos; # https://github.com/chaotic-cx/nyx
    
    # chaotic.scx = {
    #     enable = true;

    #     # https://github.com/chaotic-cx/nyx/blob/935a1f5935853e5b57f1a9432457d8bea4dbb7d7/modules/nixos/scx.nix#L15
    #     # "scx_bpfland"
    #     scheduler = "scx_lavd";
    # };

    # Source: https://github.com/D0023R/linux_kernel_15khz
    # Get sha256: ` curl *patch link* | sha256sum`
    boot.kernelPatches = [
        {
            name = "D0023R's 01 linux 15khz patch";
            patch = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/01_linux_15khz.patch";
                sha256 = "54cd58823871167adec52401ad1b6df1a36f865c6e6a5b92e9a0d711c82cde18";
            };
        }
        {
            name = "D0023R's 02 linux 15khz interlaced mode fix patch";
            patch = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/02_linux_15khz_interlaced_mode_fix.patch";
                sha256 = "fa5c70fb7557107fe06965213a0e15f3be55f13b6cfefef3c6455a33d1a36852";
            };
        }
        {
            name = "D0023R's 06 linux switchres kms drm modesetting patch";
            patch = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/06_linux_switchres_kms_drm_modesetting.patch";
                sha256 = "07607fdd6911bfd47d3497dea7b456a3c6351b325a552592d2c7bb0381015ee3";
            };
        }
        {
            name = "D0023R's 07 linux 15khz fix ddc patch";
            patch = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/07_linux_15khz_fix_ddc.patch";
                sha256 = "016a9d7a44357c25f284df80ceb1661a6fb17f2634e6920427ff79488c9cbb9a";
            };
        }
    ];

   # boot.kernelParams = [ "vga=785" "video=VGA-1-0:640x480ieS" ];
}