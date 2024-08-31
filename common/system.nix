{ config, pkgs, userSettings, ... }:

{
    # ------------ Bootloader ------------

    boot = {
        consoleLogLevel = 3;
        kernelParams = [
            "quiet"
            "systemd.show_status=auto"
            "rd.udev.log_level=3"
        ];

        # Use the systemd-boot EFI boot loader.
        loader.systemd-boot.enable = true;
        loader.systemd-boot.configurationLimit = 8;
        loader.systemd-boot.consoleMode = "max";
        loader.efi.canTouchEfiVariables = true;

        # Filesystem support
        supportedFilesystems = [
            "ntfs"
            "btrfs"
        ];

        # Boot Splash Screen
        # plymouth.enable = true;        
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
            options = "--delete-older-than 14d";
        };
    };

    # ------------ Swap ------------

    # Enable in-memory compressed devices and swap space provided by the zram kernel module.
    # By enable this, we can store more data in memory instead of fallback to disk-based swap devices directly,
    # and thus improve I/O performance when we have a lot of memory.
    #
    #   https://www.kernel.org/doc/Documentation/blockdev/zram.txt
    zramSwap = {
        enable = true;

        # one of "lzo", "lz4", "zstd"
        algorithm = "zstd";

        # Priority of the zram swap devices.
        # It should be a number higher than the priority of your disk-based swap devices
        # (so that the system will fill the zram swap devices before falling back to disk swap).
        priority = 5;

        # Maximum total amount of memory that can be stored in the zram swap devices (as a percentage of your total memory).
        # Defaults to 1/2 of your total RAM. Run zramctl to check how good memory is compressed.
        # This doesn’t define how much memory will be used by the zram swap devices.
        memoryPercent = 50;
    };

    # ------------ Timezone & Locale ------------

    # Set your time zone
    time.timeZone = "Europe/London";

    # Select internationalisation properties
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.supportedLocales = ["all"];

    # ------------ Fonts ------------

    fonts = {
        # use fonts specified by user rather than default ones
        # enableDefaultPackages = false;

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

    # ------------ Sound ------------

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    # ------------ Networking ------------

    networking = {
        networkmanager.enable = true;

        # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

        # Open ports in the firewall.
        #firewall {
            # allowedTCPPorts = [ ... ];
            # allowedUDPPorts = [ ... ];
            # Or disable the firewall altogether.
            # enable = false;
        #}
    };

    # ------------ Services ------------
    services = {
        # Enable CUPS to print documents
        printing.enable = true;

        # Allows auto detection of Network Printers
        avahi = {
            enable = true;
            nssmdns4 = true;
            openFirewall = true;
        };

        # Enable Linux Vendor Firmware Service
        fwupd.enable = true;

        # Enable the OpenSSH daemon
        openssh.enable = true;
        openssh.settings.PasswordAuthentication = true;
        openssh.settings.PermitRootLogin = "no";

        # Auto-mount USB drives
        udisks2.enable = true;

        # Samba Client
        samba = {
            enable = true;
            openFirewall = true;
            extraConfig = ''
                workgroup = WORKGROUP
                server min protocol = CORE
            '';
        };
        
        # Needed for some apps
        gnome.gnome-keyring.enable = true;
    };

    # Automatically unlock the user’s default Kwallet / Gnome Keyring upon login
    security.pam.services.${userSettings.username} = {
        kwallet.enable = true;
        enableGnomeKeyring = true;
    };
}
