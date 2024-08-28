{
	description = "Damian's Flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak?ref=<tag> to pin releases.
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
	};

	outputs = inputs@{ self, nixpkgs, nix-flatpak, home-manager, chaotic }:
	let
		userSettings = {
			username = "damian"; # Username
			name = "Damian Korcz"; # Name  / Identifier
			email = "damiankorcz28@gmail.com"; # Email
			editor = "kate";
			spawnEditor = "exec $(userSettings.terminal) -e nano";
			terminal = "konsole";
			browser = "edge"; # Default browser; must select one from ./user/app/browser/
		};
	in {
		nixosConfigurations = {
			# Desktop
			nixos-desktop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./hosts/desktop/default.nix

					nix-flatpak.nixosModules.nix-flatpak

					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						#home-manager.useUserPackages = true;
					}

					chaotic.nixosModules.default
				];
			};

			# Laptop
			nixos-laptop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./hosts/laptop/default.nix

					nix-flatpak.nixosModules.nix-flatpak

					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
					}
				];
			};

			# Raspberry Pi 4
			nixos-pi4 = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				modules = [
					./hosts/pi4/default.nix

					nix-flatpak.nixosModules.nix-flatpak

					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
					}
				];
			};
		};
	};
}
