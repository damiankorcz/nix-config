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
		#blacklistedKernelModules = [ "amdgpu" ]; # TEMP
	};

	# ------------ Storage ------------

	fileSystems = {
		"/" = { 
			device = "/dev/disk/by-label/nixos";
			fsType = "btrfs";
			options = [ "subvol=@" "noatime" ];
		};

		"/boot" = {
			device = "/dev/disk/by-label/BOOT";
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
		# https://nixos.wiki/wiki/Nvidia
		nvidia = {
			open = false;
			nvidiaSettings = true;
			modesetting.enable = true;
			powerManagement.enable = false;
			powerManagement.finegrained = false;
			package = config.boot.kernelPackages.nvidiaPackages.latest;
			
			prime = {
				# Enable render offload support using the NVIDIA proprietary driver via PRIME.
				offload.enable = true;
				
				# Found with `lspci | grep VGA` then convert values from hex to dec
				nvidiaBusId = "PCI:9:0:0";
				amdgpuBusId = "PCI:10:0:0";
			};
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
	#services.fstrim.enable = true;  # Enable periodic SSD TRIM of mounted partitions in background

	# ------------ Other ------------

	networking.useDHCP = lib.mkDefault true;

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
