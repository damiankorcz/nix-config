{
  description = "Damian's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak?ref=<tag> to pin releases.
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-flatpak, home-manager }:
    let
      systemSettings = {
        system = "x86_64-linux";
        kernel = "linuxPackages_latest";
        hostname = "nixos-desktop";
        timezone = "Europe/London";
        locale = "en_GB.UTF-8";
        keyboard = "us";
        bootMode = "uefi";
        bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
      };

      userSettings = {
        username = "damian"; # Username
        name = "Damian Korcz"; # Name  / Identifier
        email = "damiankorcz28@gmail.com"; # Email
        dotfilesDir = "~/.dotfiles"; # Absolute path of the local repo
        windowManager = "plasma"; # Window Manager or Desktop Environment
        displayManager = "x11"; # Display Server
        defaultSession = "plasmax11"; # Default Session to log into
        editor = "kate";
        spawnEditor = "exec $(userSettings.terminal) -e nano";
        terminal = "konsole";
        browser = "edge"; # Default browser; must select one from ./user/app/browser/
      };

    in {
      nixosConfigurations = {
        nixos-desktop = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;

          modules = [
            ./configuration.nix

            nix-flatpak.nixosModules.nix-flatpak

            home-manager.nixosModules.home-manager
            {
              # inherit vars;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];

          specialArgs = {
            # Pass config variables from above
            inherit systemSettings;
            inherit userSettings;
          };
        };
      };
    };
}
