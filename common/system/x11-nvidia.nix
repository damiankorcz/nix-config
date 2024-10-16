{ lib, ... }:
{
    # Trying to resolve stuttering and screen tearing
    hardware.nvidia.forceFullCompositionPipeline = true;

    # Forcing the power management to Performance
    powerManagement = {
        cpuFreqGovernor = lib.mkDefault "performance";
    };

    # Forcing kwin to believe Explicit Sync and Triple Buffer are used.
    environment.sessionVariables = {
        KWIN_EXPLICIT_SYNC = "1";
        KWIN_TRIPLE_BUFFER = "1";
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services = {
        xserver.enable = true;

        displayManager = {
            # Declares default session (Wayland = plasma / X11 = plasmax11)
            defaultSession = "plasmax11";

            # Enable Display Manager for Plasma.
            sddm.enable = true;
        };
    };
}
