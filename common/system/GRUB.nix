{ ... }:

{
    # Use GRUB Bootloader (Needed for dualbooting with Windows across several drives)
    boot.loader = {
        systemd-boot.enable = false;
        
        grub = {
            enable = true;
            device = "nodev";
            useOSProber = true;
            efiSupport = true;
            configurationLimit = 20;
            timeoutStyle = "hidden"; # Hold SHIFT during boot to show GRUB
        };

        efi.canTouchEfiVariables = true;
        efi.efiSysMountPoint = "/boot";
    };
}
