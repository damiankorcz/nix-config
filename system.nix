{ config, pkgs, lib, systemSettings,  ... }:

{
    imports = [
        ./virtualisation.nix
        ./graphics.nix
    ];

    # ------------ Bootloader & Kernel ------------

    boot = {
        # Use latest Kernel
        kernelPackages = pkgs.linuxPackages_latest;

        consoleLogLevel = 3;
        kernelParams = [
        "quiet"
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
        ];

        # Use GRUB boot loader
        # loader.grub.enable = true;
        # loader.grub.device = "/dev/sda";
        # loader.grub.useOSProber = true;
        # loader.grub.configurationLimit = 25;

        # Use the systemd-boot EFI boot loader.
        loader.systemd-boot.enable = true;
        loader.systemd-boot.configurationLimit = 25;
        loader.efi.canTouchEfiVariables = true;

        # Filesystem support
        supportedFilesystems = [
        "ntfs"
        "btrfs"
        ];

        plymouth.enable = true;
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
    time.timeZone = systemSettings.timezone;

    # Select internationalisation properties
    i18n = {
        defaultLocale = systemSettings.locale;
        extraLocaleSettings = {
            LC_ADDRESS = systemSettings.locale;
            LC_IDENTIFICATION = systemSettings.locale;
            LC_MEASUREMENT = systemSettings.locale;
            LC_MONETARY = systemSettings.locale;
            LC_NAME = systemSettings.locale;
            LC_NUMERIC = systemSettings.locale;
            LC_PAPER = systemSettings.locale;
            LC_TELEPHONE = systemSettings.locale;
            LC_TIME = systemSettings.locale;
        };
    };

    # ------------ Keyboard ------------

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = systemSettings.keyboard;
        variant = "";
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
        hostName = systemSettings.hostname; # Define your hostname.
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

    # ------------ Other Hardware & Services ------------

    hardware = {
        # Enables Xbox One Controller Adapter support
        xone.enable = true;

        # Potentially needed for Drawing Tablet Support (?)
        uinput.enable = true;

        # User-mode tablet driver
        # opentabletdriver.enable = true;

        # Firmware
        enableAllFirmware = true;
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    services = {
        # Enable CUPS to print documents
        printing.enable = true;

        # Enable Linux Vendor Firmware Service
        fwupd.enable = true;

        # Enable the OpenSSH daemon
        openssh.enable = true;
        openssh.settings.PasswordAuthentication = true;
        openssh.settings.PermitRootLogin = "no";

        # Enable touchpad support (enabled default in most desktopManager).
        # xserver.libinput.enable = true;

        # Auto-mount USB drives
        udisks2.enable = true;

        # Needed for auth tokens in Github Desktop to work (even when using KDE / Plasma). Also an issue with VSCode apparently.
        # https://nixos.wiki/wiki/Visual_Studio_Code
        gnome.gnome-keyring.enable = true;
    };

    # ------------ Time ------------

    # Fixing time sync when dualbooting with Windows
    time.hardwareClockInLocalTime = true;
}
