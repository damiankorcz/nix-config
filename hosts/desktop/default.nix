{ config, lib, pkgs, ... }:

{
	# Temp fix for amdvlk (https://github.com/NixOS/nixpkgs/issues/348903)
	nixpkgs.overlays = [
		(
			self: super: {
				amdvlk = super.amdvlk.override {
					glslang = super.glslang.overrideAttrs (finalAttrs: oldAttrs: {
						version = "15.0.0";
						src = self.fetchFromGitHub {
							owner = "KhronosGroup";
							repo = "glslang";
							rev = "refs/tags/${finalAttrs.version}";
							hash = "sha256-QXNecJ6SDeWpRjzHRTdPJHob1H3q2HZmWuL2zBt2Tlw=";
						};
					});
				};
			}
		)
	];

	imports = [
		# Hardware Config
		./hardware-configuration.nix
		../../common/system/default.nix
		../../common/system/desktop.nix
		../../common/system/GRUB.nix
		#../../common/system/x11-nvidia.nix
		../../common/system/wayland-nvidia.nix
		../../common/discord-krisp/default.nix # https://github.com/sersorrel/sys/tree/main/hm/discord

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
        	# Video Drivers
        	videoDrivers = [ "nvidia" ]; # "radeon" "modesetting" "fbdev"
		};
	    
		# Enable periodic SSD TRIM of mounted partitions in background
        fstrim.enable = true;

        # Enable the KDE Plasma Desktop Environment.
        desktopManager.plasma6.enable = true;

        # Configure keymap in X11
        xserver.xkb = {
            layout = "us";
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
