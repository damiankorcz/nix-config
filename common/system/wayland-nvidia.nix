{ lib, ... }:
{
    # Forcing the power management to Performance
    # powerManagement = {
    #     cpuFreqGovernor = lib.mkDefault "performance";
    # };

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
