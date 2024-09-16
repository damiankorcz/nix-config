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

	hardware = {
		cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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
				# Enable render offload support using the NVIDIA proprietary driver via PRIME.
				sync.enable = true;
			 
			  	# Found with `lspci | grep VGA` then convert values from hex to dec
			  	nvidiaBusId = "PCI:9:0:0";
			  	amdgpuBusId = "PCI:10:0:0";
			};
		};
	};

	# ------------ Kernel ------------

	boot = {
		initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
		initrd.kernelModules = [ ];
		kernelModules = [ "kvm-amd" ];
		extraModulePackages = [ ];

		kernelParams = [
            "video=DVI-I-1:640x480ieS"
            #"video=DVI-I-1:320x240eS"
        ];

        # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
        # boot.kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
        # boot.kernelPackages = pkgs.linuxPackages; # LTS
        # boot.kernelPackages = pkgs.linuxPackages_cachyos; # https://github.com/chaotic-cx/nyx
        kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_10.override {
            argsOverride = rec {
                version = "6.10.10";
                modDirVersion = "6.10.10";

                src = pkgs.fetchurl {
                    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
                    sha256 = "1kcvh1g3p1sj4q34ylcmm43824f97z4k695lcxnzp7pbnlsyg1z6";
                };

                # Source: https://github.com/D0023R/linux_kernel_15khz
                # Get sha256: `nix-prefetch-url --type sha256 *patch link*`
                kernelPatches = [
                    {
                        name = "D0023R's 01 linux 15khz patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.10/01_linux_15khz.patch";
                            sha256 = "066y5k413mx0x695nskfbj36z8zidldss094qpg7l5ki7215ikal";
                        };
                    }
                    # {
                    #     name = "D0023R's 02 linux 15khz interlaced mode fix patch";
                    #     patch = builtins.fetchurl {
                    #         url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.10/02_linux_15khz_interlaced_mode_fix.patch";
                    #         sha256 = "0lk8lg8k6nj5qvrzxzkc7gqmbgpk2l73l8b5d7h7y42pfpxp0p7s";
                    #     };
                    # }
                    {
                        name = "D0023R's 03 linux 15khz dcn1 dcn2 interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.10/03_linux_15khz_dcn1_dcn2_interlaced_mode_fix.patch";
                            sha256 = "11mg9drg3shzqn77sgjzz4q5926h9ifwinla2vv13qirww23dpbv";
                        };
                    }
                    {
                        name = "D0023R's 04 linux 15khz dce interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.10/04_linux_15khz_dce_interlaced_mode_fix.patch";
                            sha256 = "0prx3szbxfqn779bhkycxijqd3q3jpk3q47jjcl5xxpassbcc405";
                        };
                    }
                    {
                        name = "D0023R's 05 linux 15khz amdgpu pll fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.10/05_linux_15khz_amdgpu_pll_fix.patch";
                            sha256 = "1cbk8db8jnim601q6dj98kxicfzwb3v437z81rvngwny8ivmwhgb";
                        };
                    }
                    {
                        name = "D0023R's 06 linux switchres kms drm modesetting patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.10/06_linux_switchres_kms_drm_modesetting.patch";
                            sha256 = "1qsy060h7fy7sa92amas68dkbim3assagplp6iyx9gqid7fpyq07";
                        };
                    }
                    {
                        name = "D0023R's 07 linux 15khz fix ddc patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.10/07_linux_15khz_fix_ddc.patch";
                            sha256 = "16mvkj64hygz4w295ril4rzv2vqscsqwx06zhkr2az1m8ix9ssh1";
                        };
                    }
                ];
            };
        });
    };

	
    # chaotic.scx = {
    #     enable = true;

    #     # https://github.com/chaotic-cx/nyx/blob/935a1f5935853e5b57f1a9432457d8bea4dbb7d7/modules/nixos/scx.nix#L15
    #     # "scx_bpfland"
    #     scheduler = "scx_lavd";
    # };
}
