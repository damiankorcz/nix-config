{ config, lib, pkgs, ... }:

{
	imports = [
		# Hardware Config
		./hardware-configuration.nix
		../../common/system/default.nix
		../../common/system/desktop.nix

		# Common Config Modules
		../../common/home.nix
		../../common/samba.nix
		../../common/software/desktop.nix
		../../common/software/emulators.nix
		../../common/software/gaming.nix
		../../common/software/terminal.nix
		../../common/software/virtualization.nix
	];

	# ------------ Base System ------------

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

	# System Name / Host name
    networking.hostName = "nixos-desktop";
	networking.useDHCP = lib.mkDefault true;

    # Fixing time sync when dualbooting with Windows
    time.hardwareClockInLocalTime = true;

    services = {
		xserver = {
			# Enable the X11 windowing system.
			# You can disable this if you're only using the Wayland session.
        	enable = true;

        	# Video Drivers
        	videoDrivers = [ "nvidia" ]; # "radeon" "modesetting" "fbdev"

			# Trying to resolve stuttering and screen tearing
			screenSection = ''
				Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
				Option         "AllowIndirectGLXProtocol" "off"
				Option         "TripleBuffer" "on"
			'';
		};
	    
		# Enable periodic SSD TRIM of mounted partitions in background
        fstrim.enable = true;

        # Enable the KDE Plasma Desktop Environment.
        desktopManager.plasma6.enable = true;

        displayManager = {
            # Declares default session (Wayland = plasma / X11 = plasmax11)
            defaultSession = "plasmax11";

            # Enable Display Manager for Plasma.
            sddm = {
                enable = true;
                #wayland.enable = true;
            };
        };

        # Configure keymap in X11
        xserver.xkb = {
            layout = "us";
            variant = "";
        };
    };

	environment.sessionVariables = {
        KWIN_EXPLICIT_SYNC = "1";
        KWIN_TRIPLE_BUFFER = "1";
    };

	# ------------ Nix ------------

	# Enable Nix Flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "24.05"; # Did you read the comment?
}
