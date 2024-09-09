{
	description = "Damian's Flake";

	inputs = {
		# Official NixOS Package Source
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

		# Declarative Flatpak Manager
		# Use github:gmodena/nix-flatpak?ref=<tag> to pin releases.
		# https://github.com/gmodena/nix-flatpak
		nix-flatpak.url = "github:gmodena/nix-flatpak"; # Unstable branch.
		
		# System for managing a user environment using the Nix
		# https://github.com/nix-community/home-manager
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Chaotic's Nyx - collection of bleeding-edge and unreleased packages
		# e.g. linux_cachyos kernel, mesa_git, etc.
		# https://www.nyx.chaotic.cx/
		#chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

		# Secrets Management
		# https://github.com/mic92/sops-nix
		sops-nix = {
			url = "github:mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Declarative Disk Partitioning
		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nixpkgs, nix-flatpak, home-manager, sops-nix, disko }: #chaotic
	let
		userSettings = {
			username = "damian"; # Username
			name = "Damian Korcz"; # Name  / Identifier
			email = "damiankorcz28@gmail.com"; # Email
			editor = "kate";
			spawnEditor = "exec $(userSettings.terminal) -e micro";
			terminal = "konsole";
			browser = "edge"; # Default browser; must select one from ./user/app/browser/
		};
	in {
		nixosConfigurations = {
			# Desktop (Custom Build)
			nixos-desktop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./hosts/desktop/default.nix

					nix-flatpak.nixosModules.nix-flatpak

					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
					}

					sops-nix.nixosModules.sops

					#chaotic.nixosModules.default
				];

				specialArgs = {
					# Pass config variables from above
					inherit userSettings;
				};
			};

			# Laptop (Envy 13 2020)
			nixos-laptop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./hosts/laptop/default.nix

					nix-flatpak.nixosModules.nix-flatpak

					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
					}

					sops-nix.nixosModules.sops
				];

				specialArgs = {
					# Pass config variables from above
					inherit userSettings;
				};
			};

			# Raspberry Pi 4 (4GB)
			nixos-pi4 = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				modules = [
					./hosts/pi4/default.nix

					nix-flatpak.nixosModules.nix-flatpak

					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
					}

					sops-nix.nixosModules.sops
				];

				specialArgs = {
					# Pass config variables from above
					inherit userSettings;
				};
			};

			# Headless VM
			nixos-vm-headless = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./hosts/vm-headless/default.nix

					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
					}

					#sops-nix.nixosModules.sops
					disko.nixosModules.disko
				];

				specialArgs = {
					inherit inputs;

					# Pass config variables from above
					inherit userSettings;
				};
			};
		};
	};
}
