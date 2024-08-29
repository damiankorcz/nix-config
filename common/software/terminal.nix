{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        gh          # GitHub CLI Tool
        wget        # Download Tool
        btop        # System Monitor
        pciutils    # PCI Device Utilities
        libnotify   # Library for Sending Desktop Notifications to the Notification Daemon
        fastfetch   # System Info
        wlr-randr   # Manage monitor resolution, rotation, refresh rate, etc.
        lshw        # Detailed information on the hardware configuration
    ];
}