{ config, pkgs,  ... }:

{
    hardware = {
        graphics = {
            enable = true;
            enable32Bit = true; # Vulkan support for 32bit programs

            ## amdvlk: an open-source Vulkan driver from AMD
            extraPackages = [ pkgs.amdvlk ];
            extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
        };

        # Nvidia configuration
        nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.latest;
        };

        # AMD Configuration
        # amdgpu.legacySupport.enable = false; # Should already be set to false by default (will use `radeon`); true will use amdgpu
    };

    services.xserver.videoDrivers = [ "nvidia" ];
}
