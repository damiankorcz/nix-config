{ pkgs, ... }:

{
    # ------------ Bootloader ------------

    boot = {
        consoleLogLevel = 3;
        kernelParams = [
            "quiet"
            "systemd.show_status=auto"
            "rd.udev.log_level=3"
        ];
        
        # Filesystem support
        supportedFilesystems = [
            "ntfs"
            "btrfs"
        ];

        # Boot Splash Screen
        # plymouth.enable = true;

        # Bandaid for LVM warnings on boot
        # https://github.com/NixOS/nixpkgs/issues/342082#issuecomment-2384783512
        initrd.preLVMCommands = ''
            export LVM_SUPPRESS_FD_WARNINGS=1
        '';
    };

    # ------------ Cleanup ------------

    nix = {
        # Optimisation of the Nix Store
        optimise.automatic = true;
        optimise.dates = [ "weekly" ];

        # Garbage colection (Removes Old Snapshots)
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };

        channel.enable = false;
    };

    # Recomputes checksums and compares to current to detect corruption
    services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = [ "/" ];
    };

    # ------------ Timezone & Locale ------------

    # Set your time zone
    time.timeZone = "Europe/London";

    # Select internationalisation properties
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.supportedLocales = ["all"];

    # ------------ Fonts ------------

    fonts = {
        # Links all fonts to: `/run/current-system/sw/share/X11/font`
        fontDir.enable = true;

        packages = with pkgs; [
            font-awesome
            noto-fonts
            noto-fonts-emoji
            source-sans
            source-serif
            corefonts
            vistafonts

            # Nerdfonts
            nerd-fonts.symbols-only
            nerd-fonts.caskaydia-cove
            nerd-fonts.fira-code
            nerd-fonts.geist-mono
            nerd-fonts.blex-mono
            nerd-fonts.iosevka
            nerd-fonts.jetbrains-mono
            nerd-fonts.sauce-code-pro
            nerd-fonts.ubuntu-mono
        ];
    };

    # ------------ Networking ------------

    networking = {
        networkmanager.enable = true;

        # Open ports in the firewall.
        #firewall {
            # allowedTCPPorts = [ ... ];
            # allowedUDPPorts = [ ... ];
            # Or disable the firewall altogether.
            # enable = false;
        #}
    };

    # ------------ Hardware ------------

    hardware = {
        enableAllFirmware = true;

        graphics = {
            enable = true;

            # Vulkan support for 32bit programs
            enable32Bit = true;

            ## amdvlk: an open-source Vulkan driver from AMD
            extraPackages = [ pkgs.amdvlk ];
            extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
        };
    };

    # ------------ Services ------------
    
    services = {
        # Enable Linux Vendor Firmware Service
        fwupd.enable = true;

        # Enable the OpenSSH daemon
        openssh.enable = true;
        openssh.settings.PasswordAuthentication = true;
        openssh.settings.PermitRootLogin = "no";
    };
}
