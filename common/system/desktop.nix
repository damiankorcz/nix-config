{ userSettings, ... }:

{
    # ------------ Sound ------------

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
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

    # ------------ Services ------------

    services = {
        # Automatic Login
        displayManager = {
            autoLogin.enable = true;
            autoLogin.user = userSettings.username;
        };

        # Enable CUPS to print documents
        printing.enable = true;

        # Allows auto detection of Network Printers
        avahi = {
            enable = true;
            nssmdns4 = true;
            openFirewall = true;
        };

        # Samba Client
        samba = {
            enable = true;
            openFirewall = true;
            settings = {
                global = {
                    "workgroup" = "WORKGROUP";
                    "server min protocol" = "CORE";
                };
            };
        };

        # Duplicati (Default port: 8200)
        duplicati.enable = true;
        
        # Syncthing
        syncthing = {
            enable = true;
            openDefaultPorts = true;
            user = "${userSettings.username}";
            group = "users";
            dataDir = "/home/${userSettings.username}/Syncthing";    # Default folder for new synced folders
            configDir = "/home/${userSettings.username}/.config/syncthing";   # Folder for Syncthing's settings and keys
            guiAddress = "0.0.0.0:8384";
        };

        # Needed for some apps
        gnome.gnome-keyring.enable = true;
    };

    # Automatically unlock the user’s default Kwallet / Gnome Keyring upon login
    security.pam.services.${userSettings.username} = {
        kwallet.enable = true;
        enableGnomeKeyring = true;
    };

    # ------------ Hardware ------------

    hardware = {
        # Enables Xbox One Controller Adapter support
		xone.enable = true;

		# Non-root access to the firmware of QMK Keyboards
		keyboard.qmk.enable = true;
    };
}