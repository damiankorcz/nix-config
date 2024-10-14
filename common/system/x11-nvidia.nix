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
        #KWIN_EXPLICIT_SYNC = "1";
        #KWIN_TRIPLE_BUFFER = "1";
    };

    boot.kernelParams = [
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "nvidia.NVreg_UsePageAttributeTable=1"
    ];    
}
