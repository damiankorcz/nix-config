{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        mangohud        # Vulkan / OpenGL Overlay for System Monitoring and FPS
        lutris          # Open Source Gaming Platform
        protonup-qt     # Install / Manage Proton-GE & Luxtorpeda for Steam / Wine-GE for Lutris
    ];

    # Steam locations that should be persistent:
    #   ~/.local/share/Steam                  - Default Steam install location
    #   ~/.local/share/Steam/steamapps/common - Default Game install location
    #   ~/.steam/root                         - Symlink to `~/.local/share/Steam`
    #   ~/.steam                              - Some Symlinks & user info
    programs.steam = {
        enable = true;
        gamescopeSession.enable = true;                 # Enable GameScope Session
        remotePlay.openFirewall = true;                 # Ports for Steam Remote Play
        localNetworkGameTransfers.openFirewall = true;  # Ports for Steam Local Network Game Transfers
        # dedicatedServer.openFirewall = true;          # Ports for Source Dedicated Server
    };
}