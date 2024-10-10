{ ... }:

{
    # Use GRUB Bootloader (Needed for dualbooting with Windows across several drives)
    boot = {
        loader.systemd-boot.enable = false;
        loader.grub.enable = true;
        loader.grub.device = "nodev";
        loader.grub.useOSProber = true;
        loader.grub.efiSupport = true;
        loader.grub.configurationLimit = 8;
        loader.efi.canTouchEfiVariables = true;
        loader.efi.efiSysMountPoint = "/boot";
    };
}