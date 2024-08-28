{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	# ------------ Kernel Modules ------------

	boot = {
		initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
		initrd.kernelModules = [ ];
		kernelModules = [ "kvm-amd" ];
		extraModulePackages = [ ];
	};

	# ------------ Storage ------------

	fileSystems = {
		"/" = { 
			device = "/dev/disk/by-label/nixos";
			fsType = "btrfs";
			options = [ "subvol=@" "noatime" ];
		};

		"/boot" = {
			device = "/dev/disk/by-label/boot";
			fsType = "vfat";
			options = [ "fmask=0022" "dmask=0022" ];
		};

		"/home" = {
			device = "/dev/disk/by-label/nixos";
			fsType = "btrfs";
			options = [ "subvol=@home" ];
		};

		"/nix" = {
			device = "/dev/disk/by-label/nixos";
			fsType = "btrfs";
			options = [ "subvol=@nix" "noatime" "compress=zstd" ];
		};

		"/var/log" = {
			device = "/dev/disk/by-label/nixos";
			fsType = "btrfs";
			options = [ "subvol=@log" "noatime" "compress=zstd" ];
		};
	};

	swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

	#services.fstrim.enable = true;  # Enable periodic SSD TRIM of mounted partitions in background

	# ------------ Hardware ------------

	hardware = {
		cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

		graphics = {
			enable = true;

			# Vulkan support for 32bit programs
			enable32Bit = true;

			## amdvlk: an open-source Vulkan driver from AMD
			extraPackages = [ pkgs.amdvlk ];
			extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
		};

		# Nvidia configuration
		nvidia = {
			open = false;
			nvidiaSettings = true;
			modesetting.enable = true;
			powerManagement.enable = false;
			powerManagement.finegrained = false;
			package = config.boot.kernelPackages.nvidiaPackages.latest;
		};

		# AMD Configuration
		# amdgpu.legacySupport.enable = false; # Should already be set to false by default (will use `radeon`); true will use amdgpu 

		# Enables Xbox One Controller Adapter support
		xone.enable = true;

		# Potentially needed for Drawing Tablet Support (?)
		uinput.enable = true;

		# Non-root acces to the firmware of QMK Keyboards
		keyboard.qmk.enable = true;

		# User-mode tablet driver
		# opentabletdriver.enable = true;
	};

	services.xserver.videoDrivers = [ "nvidia" ];

	# ------------ Other ------------

	networking.useDHCP = lib.mkDefault true;

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}