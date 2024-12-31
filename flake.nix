{
	description = "Damian's Flake";

	nixConfig = {
		# override the default substituters
		substituters = [
			"https://cache.nixos.org"

			# nix community's cache server
			"https://nix-community.cachix.org"
		];

		trusted-public-keys = [
			# the default public key of cache.nixos.org, it's built-in, no need to add it here
			"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

			# nix community's cache server public key
			"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
		];
	};

	inputs = {
		# Official NixOS Package Source
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

		# NixOS Package Source with XP Pen Drivers / app
		xppen-pr.url = "github:gepbird/nixpkgs/xppen-init-v3-v4-nixos-module";

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

		# https://github.com/NixOS/nixos-hardware
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
	};

	outputs = inputs@{ self, nixpkgs, xppen-pr, nix-flatpak, home-manager, nixos-hardware }:
	let
		userSettings = {
			username = "damian"; # Username
			name = "Damian Korcz"; # Name  / Identifier
			email = "damiankorcz28@gmail.com"; # Email
			editor = "kate";
			spawnEditor = "exec $(userSettings.terminal) -e micro";
			terminal = "konsole";
			browser = "brave"; # Default browser; must select one from ./user/app/browser/
		};

	in {
		# https://github.com/nix-community/vscode-nix-ide/issues/412#issuecomment-2295386507
		formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

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
			
					{
						nix.settings.trusted-users = [ "$(userSettings.userName)" ];
					}

					nixos-hardware.nixosModules.common-cpu-amd
					nixos-hardware.nixosModules.common-gpu-nvidia-sync
					nixos-hardware.nixosModules.common-pc
					nixos-hardware.nixosModules.common-pc-ssd
				];

				specialArgs = {
					# Pass config variables from above
					inherit userSettings;

					inherit inputs;
				};
			};

			# Laptop (HP Envy 13 2020)
			nixos-laptop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./hosts/laptop/default.nix

					nix-flatpak.nixosModules.nix-flatpak

					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
					}

					nixos-hardware.nixosModules.common-cpu-intel
					nixos-hardware.nixosModules.common-gpu-intel
					nixos-hardware.nixosModules.common-gpu-nvidia
					nixos-hardware.nixosModules.common-pc
					nixos-hardware.nixosModules.common-pc-ssd
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
				];

				specialArgs = {
					# Pass config variables from above
					inherit userSettings;

					inherit inputs;
				};
			};
		};
	};
}
