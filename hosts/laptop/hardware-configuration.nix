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

	# ------------ Hardware ------------

	hardware = {
		cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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

		# Enable bluetooth
    	bluetooth.enable = true;

		# User-mode tablet driver
		# opentabletdriver.enable = true;
	};

	# ------------ Kernel Modules ------------

	boot = {
		initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
		initrd.kernelModules = [ ];
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];

		kernelParams = [ ];

		# kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
		# kernelPackages = pkgs.linuxPackages; # LTS
		# kernelPackages = pkgs.linuxPackages_cachyos; # https://github.com/chaotic-cx/nyx
		kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
	};

    
    # chaotic.scx = {
    #     enable = true;

    #     # https://github.com/chaotic-cx/nyx/blob/935a1f5935853e5b57f1a9432457d8bea4dbb7d7/modules/nixos/scx.nix#L15
    #     # "scx_bpfland"
    #     scheduler = "scx_lavd";
    # };

#     environment.etc."X11/xorg.conf.d/20-radeon.conf".text = lib.mkForce ''
# Section "Device"
#     Identifier             "Screen0"
#     Driver                 "amdgpu"
#     BusID                  "PCI:10:0:0"
# EndSection

# Section "Device"
#     Identifier             "Screen1"
#     Driver                 "nvidia"
#     BusID                  "PCI:9:0:0"
# EndSection
#     '';      

}
