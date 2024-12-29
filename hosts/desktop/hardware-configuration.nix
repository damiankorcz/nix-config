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
			package = config.boot.kernelPackages.nvidiaPackages.beta; # Temporarily on Beta before this gets fixed: https://github.com/NixOS/nixpkgs/issues/357643
			
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
        ];

        # kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
        # kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
        # kernelPackages = pkgs.linuxPackages; # LTS
        kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_12.override {
            argsOverride = rec {
                version = "6.12.5";
                modDirVersion = "6.12.5";

                src = pkgs.fetchurl {
                    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
                    sha256 = "1k9bc0lpgg29bh7zqz3pm91hhjnfyl5aw6r6hph3ha743k77y81r";
                };

                # Source: https://github.com/D0023R/linux_kernel_15khz
                # Get sha256: `nix-prefetch-url --type sha256 *patch link*`
                kernelPatches = [
                    {
                        name = "D0023R's 01 linux 15khz patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/19ba7d6653a15a976db1eccb4a2a1f3e2104618f/linux-6.12/01_linux_15khz.patch";
                            sha256 = "05w80cnv50fk0cv6pc919jvnfr2c7f17kg896pjm3j1jjlxxi2jz";
                        };
                    }
                    # {
                    #     name = "D0023R's 02 linux 15khz interlaced mode fix patch";
                    #     patch = builtins.fetchurl {
                    #         url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/19ba7d6653a15a976db1eccb4a2a1f3e2104618f/linux-6.12/02_linux_15khz_interlaced_mode_fix.patch";
                    #         sha256 = "0ad18gxdrmji5y0yy0h3p22hkvzh61smcp94ibrsan7bvd6qix15";
                    #     };
                    # }
                    {
                        name = "D0023R's 03 linux 15khz dcn1 dcn2 interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/104584d9816c50bbd3e8529521d7a3f230028fcc/linux-6.12/03_linux_15khz_dcn1_dcn2_interlaced_mode_fix.patch";
                            sha256 = "0wpf1lfc283bmqag2kbjjph93b9gg6v4fwqhaprvw6bpbgvklbxg";
                        };
                    }
                    {
                        name = "D0023R's 04 linux 15khz dce interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/19ba7d6653a15a976db1eccb4a2a1f3e2104618f/linux-6.12/04_linux_15khz_dce_interlaced_mode_fix.patch";
                            sha256 = "1wpyxqvi03bxnsa2xw0lpmr1gvfw3ll841bd80lkm6vrdjf8k88v";
                        };
                    }
                    {
                        name = "D0023R's 05 linux 15khz amdgpu pll fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/19ba7d6653a15a976db1eccb4a2a1f3e2104618f/linux-6.12/05_linux_15khz_amdgpu_pll_fix.patch";
                            sha256 = "15yiqpa8j802yv33p5hx887ixfkk7wqg52hggksqgf2vc4kssxwh";
                        };
                    }
                    {
                        name = "D0023R's 06 linux switchres kms drm modesetting patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/19ba7d6653a15a976db1eccb4a2a1f3e2104618f/linux-6.12/06_linux_switchres_kms_drm_modesetting.patch";
                            sha256 = "162c8vknl6n5gldffh9a04mlzcss97q4aid9h8mlqfca6fqazv2w";
                        };
                    }
                    {
                        name = "D0023R's 07 linux 15khz fix ddc patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/19ba7d6653a15a976db1eccb4a2a1f3e2104618f/linux-6.12/07_linux_15khz_fix_ddc.patch";
                            sha256 = "18vpy1j8zshznvc662zgqjln391qhr95wy53hvbq7z8fdv5xvpdg";
                        };
                    }
                ];
            };
        });
    };
}
