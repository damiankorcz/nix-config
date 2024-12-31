{ lib, ... }:

{
	imports = [
		# Hardware Config
		./hardware-configuration.nix
		../../common/system/default.nix
		../../common/system/desktop.nix
		../../common/system/systemd-boot.nix
		#../../common/system/x11-nvidia.nix
		../../common/system/wayland-nvidia.nix
		../../common/system/nvidia-offload.nix

		# Common Config Modules
		../../common/home.nix
		../../common/samba.nix
		../../common/software/desktop.nix
		../../common/software/development.nix
		../../common/software/terminal.nix
		../../common/software/gaming.nix
		# ../../common/software/emulators.nix
		#../../common/software/virtualization.nix
	];

	# ------------ Base System ------------
	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

	networking = {
		# System Name / Host name
		hostName = "nixos-laptop";

		useDHCP = lib.mkDefault false;
		interfaces.wlan0.useDHCP = lib.mkDefault true;

		# Enables wireless and changes the backend to iwd
		# https://nixos.wiki/wiki/Iwd
		wireless.iwd.enable = true;

		networkmanager.wifi.backend = "iwd";
	};

	# Fixing time sync when dualbooting with Windows
	time.hardwareClockInLocalTime = true;

	services = {
		# Video Drivers
		xserver.videoDrivers = [ "nvidia" ]; # "modesetting" "fbdev"

		# Enable periodic SSD TRIM of mounted partitions in background
		fstrim.enable = true;

		# Enable the KDE Plasma Desktop Environment.
		desktopManager.plasma6.enable = true;

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
