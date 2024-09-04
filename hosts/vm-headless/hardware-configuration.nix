{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	# ------------ Storage ------------

	fileSystems = {
		"/" =
		{
			device = "/dev/disk/by-label/nixos";
			fsType = "btrfs";
			options = [ "subvol=@" "noatime" ];
		};

		"/boot" =
		{
			device = "/dev/disk/by-label/BOOT";
			fsType = "vfat";
			options = [ "fmask=0022" "dmask=0022" ];
		};

		"/home" =
		{
			device = "/dev/disk/by-label/nixos";
			fsType = "btrfs";
			options = [ "subvol=@home" ];
		};

		"/nix" =
		{
			device = "/dev/disk/by-label/nixos";
			fsType = "btrfs";
			options = [ "subvol=@nix" "noatime" "compress=zstd" ];
		};

		"/var/log" =
		{
			device = "/dev/disk/by-label/nixos";
			fsType = "btrfs";
			options = [ "subvol=@log" "noatime" "compress=zstd" ];
		};
	};
	
	swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

	# ------------ Kernel Modules ------------

	boot = {
		initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
		initrd.kernelModules = [ ];
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];

		kernelParams = [ ];

		# kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
		# kernelPackages = pkgs.linuxPackages; # LTS
		kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
	};
}
