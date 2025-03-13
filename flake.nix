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

    # https://github.com/NixOS/nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # https://github.com/chaotic-cx/nyx
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    tagstudio = {
      url = "github:TagStudioDev/TagStudio";
      inputs.nixpkgs.follows = "nixpkgs"; # Use the same package set as your flake.
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      xppen-pr,
      nix-flatpak,
      nixos-hardware,
      chaotic,
      tagstudio,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux"; # Adjust based on your architecture
        overlays = [
          import
          ./overlays/lact-overlay.nix # Import the custom overlay
        ];
      };

      userSettings = {
        username = "damian"; # Username
        name = "Damian Korcz"; # Name  / Identifier
        email = "damiankorcz28@gmail.com"; # Email
        editor = "kate";
        spawnEditor = "exec $(userSettings.terminal) -e micro";
        terminal = "konsole";
        browser = "brave"; # Default browser; must select one from ./user/app/browser/
      };
    in
    {
      nixosConfigurations = {
        # Desktop (Custom Build)
        nixos-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./hosts/desktop/default.nix

            nix-flatpak.nixosModules.nix-flatpak

            {
              nix.settings.trusted-users = [ "$(userSettings.userName)" ];
            }

            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-amd
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-pc-ssd

            chaotic.nixosModules.default
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
