{ lib, ... }:
{
    # Forcing the power management to Performance
    # powerManagement = {
    #     cpuFreqGovernor = lib.mkDefault "performance";
    # };

    # Enable the KDE Plasma Desktop Environment.
    desktopManager.plasma6.enable = true;

    services.displayManager = {
        # Declares default session (Wayland = plasma / X11 = plasmax11)
        defaultSession = "plasma";

        # Enable Display Manager for Plasma.
        sddm = {
            enable = true;
            wayland.enable = true;
        };
    };
}
