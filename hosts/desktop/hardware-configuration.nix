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
			
			# prime = {
			# 	# Enable render offload support using the NVIDIA proprietary driver via PRIME.
			# 	sync.enable = true;
			
			# 	# Found with `lspci | grep VGA` then convert values from hex to dec
			# 	nvidiaBusId = "PCI:9:0:0";
			# 	amdgpuBusId = "PCI:10:0:0";
			# };
		};
	};

	# ------------ Kernel ------------

	boot = {
		initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
		initrd.kernelModules = [ ];
		kernelModules = [ "kvm-amd" ];
		extraModulePackages = [ ];

		kernelParams = [
            #"video=VGA-1:640x480ieS"
            #"video=VGA-1:320x240eS"
            # "radeon.modeset=0"
        ];

        # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
        # boot.kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
        # boot.kernelPackages = pkgs.linuxPackages; # LTS
        # boot.kernelPackages = pkgs.linuxPackages_cachyos; # https://github.com/chaotic-cx/nyx
        kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_10.override {
            argsOverride = rec {
                version = "6.10.6";
                modDirVersion = "6.10.6";

                src = pkgs.fetchurl {
                    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
                    sha256 = "4NUNW3T4WZN1Zg558YevdJOGTbpf9mcbFJgzdqBws9E=";
                };

                # Source: https://github.com/D0023R/linux_kernel_15khz
                # Get sha256: `nix-prefetch-url --type sha256 *patch link*`
                kernelPatches = [
                    {
                        name = "D0023R's 01 linux 15khz patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/01_linux_15khz.patch";
                            sha256 = "54cd58823871167adec52401ad1b6df1a36f865c6e6a5b92e9a0d711c82cde18";
                        };
                    }
                    # {
                    #     name = "D0023R's 02 linux 15khz interlaced mode fix patch";
                    #     patch = builtins.fetchurl {
                    #         url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/02_linux_15khz_interlaced_mode_fix.patch";
                    #         sha256 = "fa5c70fb7557107fe06965213a0e15f3be55f13b6cfefef3c6455a33d1a36852";
                    #     };
                    # }
                    # amdgpu specific patches
                    {
                        name = "D0023R's 03 linux 15khz dcn1 dcn2 interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/03_linux_15khz_dcn1_dcn2_interlaced_mode_fix.patch";
                            sha256 = "b0cb5bbb5427512111b7ce60ab35efb3bdc3d505111d618e93dd352f4f5bcd29";
                        };
                    }
                    {
                        name = "D0023R's 04 linux 15khz dce interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/04_linux_15khz_dce_interlaced_mode_fix.patch";
                            sha256 = "0510c696d6eaf65e2893f2103ce695038f8665eccc4fb8d23916bbbebe1e3d5f";
                        };
                    }
                    {
                        name = "D0023R's 05 linux 15khz amdgpu pll fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/05_linux_15khz_amdgpu_pll_fix.patch";
                            sha256 = "eb415e7744def267770ee89f41f658fc3b16fb444936830330355a89564373b1";
                        };
                    }
                    {
                        name = "D0023R's 06 linux switchres kms drm modesetting patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/06_linux_switchres_kms_drm_modesetting.patch";
                            sha256 = "07607fdd6911bfd47d3497dea7b456a3c6351b325a552592d2c7bb0381015ee3";
                        };
                    }
                    {
                        name = "D0023R's 07 linux 15khz fix ddc patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/07_linux_15khz_fix_ddc.patch";
                            sha256 = "016a9d7a44357c25f284df80ceb1661a6fb17f2634e6920427ff79488c9cbb9a";
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

# services.xserver.config = {
#   Device = [
#     {
#       Identifier = "AMD";
#       Driver = "amdgpu";
#       BusID = "PCI:10:0:0"; # Adjust according to your system
#     }
#     {
#       Identifier = "Nvidia";
#       Driver = "nvidia";
#       BusID = "PCI:9:0:0"; # Adjust according to your system
#     }
#   ];
# };

}
