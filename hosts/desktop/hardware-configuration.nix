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
			powerManagement.enable = true;
			powerManagement.finegrained = false;
            #forceFullCompositionPipeline = true;
			package = config.boot.kernelPackages.nvidiaPackages.latest;
			
			prime = {
				# NVIDIA GPU is always on (does all rendering). Output enabled to displays attached only to the integrated Intel/AMD GPU without a multiplexer.
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
        kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_11.override {
            argsOverride = rec {
                version = "6.11";
                modDirVersion = "6.11.0";

                src = pkgs.fetchurl {
                    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
                    sha256 = "0bnbvadm4wvnwzcq319gsgl03ijvvljn7mj8qw87ihpb4p0cdljm";
                };

                # Source: https://github.com/D0023R/linux_kernel_15khz
                # Get sha256: `nix-prefetch-url --type sha256 *patch link*`
                kernelPatches = [
                    {
                        name = "D0023R's 01 linux 15khz patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.11/01_linux_15khz.patch";
                            sha256 = "17gdv90y3kyc4mhim55aj1l75kxmyv0hmbhchs98d8mcigchyl1f";
                        };
                    }
                    # {
                    #     name = "D0023R's 02 linux 15khz interlaced mode fix patch";
                    #     patch = builtins.fetchurl {
                    #         url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.11/02_linux_15khz_interlaced_mode_fix.patch";
                    #         sha256 = "0lk8lg8k6nj5qvrzxzkc7gqmbgpk2l73l8b5d7h7y42pfpxp0p7s";
                    #     };
                    # }
                    {
                        name = "D0023R's 03 linux 15khz dcn1 dcn2 interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.11/03_linux_15khz_dcn1_dcn2_interlaced_mode_fix.patch";
                            sha256 = "13iqqhvgrzyd72b8101q6qv66yld0lr3vyfbaas4af338b7gydxv";
                        };
                    }
                    {
                        name = "D0023R's 04 linux 15khz dce interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.11/04_linux_15khz_dce_interlaced_mode_fix.patch";
                            sha256 = "0dhlvvklqymg43wv4nfs9r9db9qfi2adv9mvr97hm3j77g9rxv5g";
                        };
                    }
                    {
                        name = "D0023R's 05 linux 15khz amdgpu pll fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.11/05_linux_15khz_amdgpu_pll_fix.patch";
                            sha256 = "1cbk8db8jnim601q6dj98kxicfzwb3v437z81rvngwny8ivmwhgb";
                        };
                    }
                    {
                        name = "D0023R's 06 linux switchres kms drm modesetting patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/b86d4a3b87eef1fc258636cbea999563e97088a0/linux-6.11/06_linux_switchres_kms_drm_modesetting.patch";
                            sha256 = "1kw1ih10gy6jrrxxf4yd4g8lb72k3nnlxb242jbiwdpx171zpiid";
                        };
                    }
                    {
                        name = "D0023R's 07 linux 15khz fix ddc patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/9fadc65e58a67bae04e0ee3c80dcb534f80e6460/linux-6.11/07_linux_15khz_fix_ddc.patch";
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
