{ ... }:

{
    # Use the systemd-boot EFI boot loader.
    boot = {
        loader.systemd-boot.enable = true;
        loader.systemd-boot.configurationLimit = 20;
        loader.systemd-boot.consoleMode = "max";
        loader.efi.canTouchEfiVariables = true;
    };
}
