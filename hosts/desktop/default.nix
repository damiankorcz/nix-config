{ config, pkgs,  ... }:

{
	imports = [
		# Hardware Config
		./hardware-configuration.nix
		./common/system.nix
		./system.nix

		# Common Config Modules
		./common/home.nix
		./common/samba.nix
		./common/software/default.nix
		./common/software/gaming.nix
		./common/software/terminal.nix
		./common/software/emulators.nix
	];

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
