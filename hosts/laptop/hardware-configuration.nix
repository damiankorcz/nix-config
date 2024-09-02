{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	# ------------ Kernel Modules ------------

	boot = {
		initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
		initrd.kernelModules = [ ];
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
	};

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

	# ------------ Hardware ------------

	hardware = {
		#enableAllFirmware = true;
		cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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
			package = config.boot.kernelPackages.nvidiaPackages.stable;
			
			prime = {
				# Enable NVIDIA Optimus support using the NVIDIA proprietary driver via PRIME
				sync.enable = true;
				
				# Found with `lspci` then convert values from hex to dec
				nvidiaBusId = "PCI:1:0:0";
				intelBusId = "PCI:0:2:0";
			};
		};

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
	
	services.fstrim.enable = true; # Enable periodic SSD TRIM of mounted partitions in background

	networking.useDHCP = lib.mkDefault false;
	networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
