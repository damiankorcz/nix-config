{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ------------ Storage ------------

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "noatime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "noatime"
        "compress=zstd"
      ];
    };

    "/var/log" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "noatime"
        "compress=zstd"
      ];
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  # ------------ Hardware ------------
  
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware = {
    cpu.amd = {
      updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      ryzen-smu.enable = true; # kernel driver that exposes access to the SMU (System Management Unit). Needed for Undervolting script.
    };

    # Enable amdgpu kernel driver for Southern Islands and Sea Islands cards.
    amdgpu.legacySupport.enable = true;
  };

  # ------------ Kernel ------------

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];

    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    kernelParams = [
      "video=DVI-I-1:640x480ieS"
      #"video=DVI-I-1:320x240eS"
      "amd_pstate=guided"
      "amdgpu.ppfeaturemask=0xfffd7fff" # Enables Overclocking on AMD GPU
    ];

    # kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
    # kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
    # kernelPackages = pkgs.linuxPackages; # LTS

    # kernelPackages = pkgs.linuxPackages_testing;

    kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linux_6_14.override {
        argsOverride = rec {
          version = "6.14.3";
          modDirVersion = "6.14.3";

          # Get sha256: `nix-prefetch-url --type sha256 *url*`
          src = pkgs.fetchurl {
            url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
            sha256 = "0ak5av0ykf8m65dmbihlcx9ahb1p8rgx6bm04acz0s15qcic7ili";
          };

          # Source: https://github.com/D0023R/linux_kernel_15khz
          kernelPatches = [
            {
              name = "D0023R's 01 linux 15khz";
              patch = ../../scripts/15Khz/01_linux_15khz.patch;
            }
            # {
            #   name = "D0023R's 02 linux 15khz interlaced mode fix";
            #   patch = ../../scripts/15Khz/02_linux_15khz_interlaced_mode_fix.patch;
            # }
            {
              name = "D0023R's 03 linux 15khz dcn1 dcn2 interlaced mode fix";
              patch = ../../scripts/15Khz/03_linux_15khz_dcn1_dcn2_dcn3_interlaced_mode_fix.patch;
            }
            {
              name = "D0023R's 04 linux 15khz dce interlaced mode fix";
              patch = ../../scripts/15Khz/04_linux_15khz_dce_interlaced_mode_fix.patch;
            }
            {
              name = "0023R's 05 linux 15khz amdgpu pll fix";
              patch = ../../scripts/15Khz/05_linux_15khz_amdgpu_pll_fix.patch;
            }
            {
              name = "D0023R's 06 linux switchres kms drm modesetting";
              patch = ../../scripts/15Khz/06_linux_switchres_kms_drm_modesetting.patch;
            }
            {
              name = "D0023R's 07 linux 15khz fix ddc";
              patch = ../../scripts/15Khz/07_linux_15khz_fix_ddc.patch;
            }
          ];
        };
      }
    );
  };
}
