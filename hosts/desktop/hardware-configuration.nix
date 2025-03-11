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
    ];

    # kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://xanmod.org/
    # kernelPackages = pkgs.linuxPackages_latest; # Latest Stable
    # kernelPackages = pkgs.linuxPackages; # LTS

    kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linux_6_13.override {
        argsOverride = rec {
          version = "6.13.6";
          modDirVersion = "6.13.6";

          src = pkgs.fetchurl {
            url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
            sha256 = "3gBTy0E9QI8g/R1XiCGZUbikQD5drBsdkDIJCTis0Zk=";
          };

          # Source: https://github.com/D0023R/linux_kernel_15khz
          # Get sha256: `nix-prefetch-url --type sha256 *patch link*`
          kernelPatches = [
            {
              name = "D0023R's 01 linux 15khz patch";
              patch = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/7932ec9bfcb0122c3f79664934f9782ed053bcb6/linux-6.13/01_linux_15khz.patch";
                sha256 = "1kyp6swm96nhrfcylyfj55b3i7ysk052ysf3blczkrphl5b7lvwr";
              };
            }
            # {
            #     name = "D0023R's 02 linux 15khz interlaced mode fix patch";
            #     patch = builtins.fetchurl {
            #         url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/7932ec9bfcb0122c3f79664934f9782ed053bcb6/linux-6.13/02_linux_15khz_interlaced_mode_fix.patch";
            #         sha256 = "0h9lwxrw55dgv3sxphpiqpvbkgxpqflqg9z6jablzmm0s25ml87p";
            #     };
            # }
            {
              name = "D0023R's 03 linux 15khz dcn1 dcn2 interlaced mode fix patch";
              patch = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/c1ff219c9663ccdd97e123990083ae623cdafa3d/linux-6.13/03_linux_15khz_dcn1_dcn2_dcn3_interlaced_mode_fix.patch";
                sha256 = "19i946yl5k56s7p4xczc39jialfsxwkxmpdqn1pma8wy7mhsymgp";
              };
            }
            {
              name = "D0023R's 04 linux 15khz dce interlaced mode fix patch";
              patch = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/7932ec9bfcb0122c3f79664934f9782ed053bcb6/linux-6.13/04_linux_15khz_dce_interlaced_mode_fix.patch";
                sha256 = "028y2zbhcq5xy3q9pwg9n9wb6r02ivqkzs5kqa58k2yb6h1p3qc5";
              };
            }
            {
              name = "D0023R's 05 linux 15khz amdgpu pll fix patch";
              patch = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/7932ec9bfcb0122c3f79664934f9782ed053bcb6/linux-6.13/05_linux_15khz_amdgpu_pll_fix.patch";
                sha256 = "073wgsbbc2z6y3y8ida9yp5k3ja89z8a29m3pmsmp730ykliswhv";
              };
            }
            {
              name = "D0023R's 06 linux switchres kms drm modesetting patch";
              patch = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/c1ff219c9663ccdd97e123990083ae623cdafa3d/linux-6.13/06_linux_switchres_kms_drm_modesetting.patch";
                sha256 = "19wab4hpcr3if1zac2gyz9p7mz2dq56r62nfqi4mwsaaafiy1gp7";
              };
            }
            {
              name = "D0023R's 07 linux 15khz fix ddc patch";
              patch = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/D0023R/linux_kernel_15khz/7932ec9bfcb0122c3f79664934f9782ed053bcb6/linux-6.13/07_linux_15khz_fix_ddc.patch";
                sha256 = "1zjs673f6581z58vppxban045dvp1qcr6vvaz9mjv9inz195bqf2";
              };
            }
          ];
        };
      }
    );
  };
}
