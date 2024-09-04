{ config, pkgs, ... }:

{
	imports = [
		# Hardware Config
		./hardware-configuration.nix
		../../common/system/default.nix

		# Common Config Modules
		../../common/home.nix
		../../common/samba.nix
		../../common/software/terminal.nix
	];

	# ------------ Base System ------------
	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	
	networking = {
		# System Name / Host name
		hostName = "nixos-vm-headless";

		useDHCP = lib.mkDefault false;
	};

	virtualisation.vmware.guest.enable = true;

    services = {
        # Enable the X11 windowing system.
        # You can disable this if you're only using the Wayland session.
        # xserver.enable = true;

		services.xserver.videoDrivers = [ "vmware" ];
	
        # Configure keymap in X11
        xserver.xkb = {
            layout = "gb";
            variant = "";
        };
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
