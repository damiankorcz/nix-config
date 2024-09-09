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
            #"video=HDMI-1-0:2560x1440@60"
            #"video=DP-1-2:2560x1440@144"
            #"video=DP-1-4:2560x1440"
            #"video=DVI-I-1:320x240eS"
            # "radeon.modeset=0"
        ];

        # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
        # boot.kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
        # boot.kernelPackages = pkgs.linuxPackages; # LTS
        # boot.kernelPackages = pkgs.linuxPackages_cachyos; # https://github.com/chaotic-cx/nyx
        kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_10.override {
            argsOverride = rec {
                version = "6.10.8";
                modDirVersion = "6.10.8";

                src = pkgs.fetchurl {
                    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
                    sha256 = "wJIyNXedRga7qH9ytv4R95bp5AwcqfTV2+BM1H7jxZU=";
                };

                # Source: https://github.com/D0023R/linux_kernel_15khz
                # Get sha256: `nix-prefetch-url --type sha256 *patch link*`
                kernelPatches = [
                    {
                        name = "D0023R's 01 linux 15khz patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/01_linux_15khz.patch";
                            sha256 = "066y5k413mx0x695nskfbj36z8zidldss094qpg7l5ki7215ikal";
                        };
                    }
                    # {
                    #     name = "D0023R's 02 linux 15khz interlaced mode fix patch";
                    #     patch = builtins.fetchurl {
                    #         url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/02_linux_15khz_interlaced_mode_fix.patch";
                    #         sha256 = "0lk8lg8k6nj5qvrzxzkc7gqmbgpk2l73l8b5d7h7y42pfpxp0p7s";
                    #     };
                    # }
                    {
                        name = "D0023R's 03 linux 15khz dcn1 dcn2 interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/03_linux_15khz_dcn1_dcn2_interlaced_mode_fix.patch";
                            sha256 = "07r0c7zmv9nd2258hs5i6jz3v3jna5g05cbf20k8lafalacrcjal";
                        };
                    }
                    {
                        name = "D0023R's 04 linux 15khz dce interlaced mode fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/04_linux_15khz_dce_interlaced_mode_fix.patch";
                            sha256 = "0prx3szbxfqn779bhkycxijqd3q3jpk3q47jjcl5xxpassbcc405";
                        };
                    }
                    {
                        name = "D0023R's 05 linux 15khz amdgpu pll fix patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/05_linux_15khz_amdgpu_pll_fix.patch";
                            sha256 = "1cbk8db8jnim601q6dj98kxicfzwb3v437z81rvngwny8ivmwhgb";
                        };
                    }
                    {
                        name = "D0023R's 06 linux switchres kms drm modesetting patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/06_linux_switchres_kms_drm_modesetting.patch";
                            sha256 = "1qsy060h7fy7sa92amas68dkbim3assagplp6iyx9gqid7fpyq07";
                        };
                    }
                    {
                        name = "D0023R's 07 linux 15khz fix ddc patch";
                        patch = builtins.fetchurl {
                            url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/master/linux-6.10/07_linux_15khz_fix_ddc.patch";
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

# environment.etc."X11/xorg.conf.d/20-radeon.conf".text = lib.mkForce ''
#  Section "Device"
#      Identifier             "Screen0"
#      Driver                 "amdgpu"
#      BusID                  "PCI:10:0:0"
#  EndSection
# 
#  Section "Device"
#      Identifier             "Screen1"
#      Driver                 "nvidia"
#      BusID                  "PCI:9:0:0"
#  EndSection
# '';      

#services.xserver.config = ''
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
# '';
# 
#services.xserver.xrandrHeads = [
#  {
#     output = "DVI-I-0";
#     name = "CRT";
#     mode = "640x480ieS";
#     position = {
#       x = 4000;
#       y = 2472;
#     };
#     rotation = "normal";
#   }
 #   {
 #     output = "HDMI-A-1";
 #     name = "Portrait";
 #     mode = "2560x1440";
 #     position = {
 #       x = 0;
 #       y = 392;
 #     };
 #     rotation = "left";
 #   }
 #   {
 #     output = "DP-3";
 #     name = "Main";
 #     primary = true;
 #     mode = "2560x1440";
 #     position = {
 #       x = 1440;
 #       y = 72;
 #     };
 #     rotation = "normal";
 #   }
 #   {
 #     output = "DP-4";
 #     name = "Top";
 #     mode = "2560x1440";
 #     position = {
 #       x = 1440;
 #       y = 1512;
 #     };
 #     rotation = "normal";
 #   }
 # ];

# services.xserver.monitorSection = ''
# 	Section "Monitor"
# 	    Identifier "DVI-I-0"
# 	    Option "Position" "4000 2472"
# 	    Option "Rotate" "normal"
# 	EndSection
# 
# 	Section "Monitor"
# 	    Identifier "HDMI-1-0"
# 	    Option "PreferredMode" "2560x1440"
# 	    Option "Position" "0 392"
# 	    Option "Rotate" "left"
# 	EndSection
# 
# 	Section "Monitor"
# 	    Identifier "DP-1-2"
# 	    Option "Primary" "true"
# 	    Option "PreferredMode" "2560x1440"
# 	    Option "Position" "1440 72"
# 	    Option "Rotate" "normal"
# 	EndSection
# 
# 	Section "Monitor"
# 	    Identifier "DP-1-4"
# 	    Option "PreferredMode" "2560x1440"
# 	    Option "Position" "1440 1512"
# 	    Option "Rotate" "normal"
# 	EndSection
# '';

# environment.etc."X11/xorg.conf.d/10-monitor.conf".text = ''
#   Section "Monitor"
#     Identifier "DVI-I-0"
#     Option "Position" "4000 2472"
#     Option "Rotate" "normal"
#   EndSection

#   Section "Monitor"
#     Identifier "HDMI-1-0"
#     Option "PreferredMode" "2560x1440"
#     Option "Position" "0 392"
#     Option "Rotate" "left"
#   EndSection

#   Section "Monitor"
#     Identifier "DP-1-2"
#     Option "Primary" "true"
#     Option "PreferredMode" "2560x1440"
#     Option "Position" "1440 72"
#     Option "Rotate" "normal"
#   EndSection

#   Section "Monitor"
#     Identifier "DP-1-4"
#     Option "PreferredMode" "2560x1440"
#     Option "Position" "1440 1512"
#     Option "Rotate" "normal"
#   EndSection
# '';
}
