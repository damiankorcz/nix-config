{ lib, pkgs, ... }:

{
	imports = [
		# Hardware Config
		./hardware-configuration.nix
		../../common/system/default.nix
		../../common/system/desktop.nix
		../../common/system/GRUB.nix
		#../../common/system/x11-nvidia.nix
		../../common/system/wayland-nvidia.nix

		# Common Config Modules
		../../common/home.nix
		../../common/samba.nix
		../../common/software/obs.nix
		../../common/software/xppen.nix
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
		# Video Drivers
		xserver.videoDrivers = [ "nvidia" ]; # "radeon" "modesetting" "fbdev"

		# Enable periodic SSD TRIM of mounted partitions in background
		fstrim.enable = true;

		# Configure keymap in X11
		xserver.xkb = {
			layout = "us";
			variant = "";
		};
	};

	systemd.services."undervolt" = {
		enable = true;
		description = "This Service runs a Python script to undervolt the 5700X3D CPU.";

		unitConfig = {
			Type = "simple";
			After = [ "sleep.target" "multi-user.target" ];
		};

		serviceConfig = {
			User= "root";
			ExecStart = "${pkgs.python313}/bin/python /home/damian/Git/nix-config/scripts/undervolt.py -c 8 -o -30";
		};

		wantedBy = [ "sleep.target" "multi-user.target" ];
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
