{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

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
    
    services.xserver.videoDrivers = [ "nvidia" ];

	hardware = {
        cpu.amd = {
            updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
            ryzen-smu.enable = true; # kernel driver that exposes access to the SMU (System Management Unit). Needed for Undervolting script.
        };

		# Enable amdgpu kernel driver for Southern Islands and Sea Islands cards.
		amdgpu.legacySupport.enable = true;

		# Nvidia configuration
		# https://nixos.wiki/wiki/Nvidia
        nvidia = {
            open = true;
			nvidiaSettings = true;
			modesetting.enable = true;
			powerManagement.enable = false;
			powerManagement.finegrained = false;
			package = config.boot.kernelPackages.nvidiaPackages.latest;
			
			prime = {
				# NVIDIA GPU is always on (does all rendering). Output enabled to displays attached only to the integrated Intel/AMD GPU without a multiplexer.
				sync.enable = true;
			 
			  	# Found with `lspci | grep VGA` then convert values from hex to dec
			  	nvidiaBusId = "PCI:9:0:0";
			  	amdgpuBusId = "PCI:4:0:0"; # "PCI:10:0:0" when in the other main slot 
			};
		};
	};

	# ------------ Kernel ------------

	boot = {
		initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
		initrd.kernelModules = [ ];
		kernelModules = [ "kvm-amd" ];
		extraModulePackages = [ ];

        blacklistedKernelModules = lib.mkDefault [ "nouveau" ];

        kernelParams = [
            "video=DVI-I-1:640x480ieS"
            #"video=DVI-I-1:320x240eS"
            "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
            "nvidia.NVreg_UsePageAttributeTable=1"
            "amd_pstate=guided"
        ];

        # kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
        # kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
        # kernelPackages = pkgs.linuxPackages; # LTS
        kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_13.override {
            argsOverride = rec {
                version = "6.13";
                modDirVersion = "6.13.0";

                src = pkgs.fetchurl {
                    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
                    sha256 = "0vhdz1as27kxav81rkf6fm85sqrbj5hjhz5hpyxcd5b6p1pcr7g7";
                };

                # Source: https://github.com/D0023R/linux_kernel_15khz
                # Get sha256: `nix-prefetch-url --type sha256 *patch link*`
                kernelPatches = [
                    {
                        name = "D0023R's 01 linux 15khz patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/c7342cd650cfb53a811c491a5c09fb8f9cb802b5/linux-6.13/01_linux_15khz.patch";
                            sha256 = "1kyp6swm96nhrfcylyfj55b3i7ysk052ysf3blczkrphl5b7lvwr";
                        };
                    }
                    # {
                    #     name = "D0023R's 02 linux 15khz interlaced mode fix patch";
                    #     patch = builtins.fetchurl {
                    #         url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/c7342cd650cfb53a811c491a5c09fb8f9cb802b5/linux-6.13/02_linux_15khz_interlaced_mode_fix.patch";
                    #         sha256 = "0pnl61pqddhpr3ka5h8am7vzg7p2g52f9hrz2qzji2cdym251di7";
                    #     };
                    # }
                    {
                        name = "D0023R's 03 linux 15khz dcn1 dcn2 interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/c7342cd650cfb53a811c491a5c09fb8f9cb802b5/linux-6.13/03_linux_15khz_dcn1_dcn2_dcn3_interlaced_mode_fix.patch";
                            sha256 = "1w8p1fnjhidwaf2g8mqc13lil7dhniy4fplm24dfhkcrgs2aj5fl";
                        };
                    }
                    {
                        name = "D0023R's 04 linux 15khz dce interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/c7342cd650cfb53a811c491a5c09fb8f9cb802b5/linux-6.13/04_linux_15khz_dce_interlaced_mode_fix.patch";
                            sha256 = "028y2zbhcq5xy3q9pwg9n9wb6r02ivqkzs5kqa58k2yb6h1p3qc5";
                        };
                    }
                    {
                        name = "D0023R's 05 linux 15khz amdgpu pll fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/c7342cd650cfb53a811c491a5c09fb8f9cb802b5/linux-6.13/05_linux_15khz_amdgpu_pll_fix.patch";
                            sha256 = "073wgsbbc2z6y3y8ida9yp5k3ja89z8a29m3pmsmp730ykliswhv";
                        };
                    }
                    {
                        name = "D0023R's 06 linux switchres kms drm modesetting patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/c7342cd650cfb53a811c491a5c09fb8f9cb802b5/linux-6.13/06_linux_switchres_kms_drm_modesetting.patch";
                            sha256 = "00i5b94xmb9x20frcsgyr61ys6lfzpsnda4kdysw7glcj686cca4";
                        };
                    }
                    {
                        name = "D0023R's 07 linux 15khz fix ddc patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/c7342cd650cfb53a811c491a5c09fb8f9cb802b5/linux-6.13/07_linux_15khz_fix_ddc.patch";
                            sha256 = "1zjs673f6581z58vppxban045dvp1qcr6vvaz9mjv9inz195bqf2";
                        };
                    }
                ];
            };
        });
    };
}
