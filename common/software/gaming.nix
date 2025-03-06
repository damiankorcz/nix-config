{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mangohud # Vulkan / OpenGL Overlay for System Monitoring and FPS
    lutris # Open Source Gaming Platform
    protonup-qt # Install / Manage Proton-GE & Luxtorpeda for Steam / Wine-GE for Lutris
    protonplus
    libnotify # Library for Sending Desktop Notifications to the Notification Daemon
    prismlauncher # Launcher for Minecraft

    #moonlight-qt    # Play your PC games on almost any device

    # Sched-ext userspace Schedulers (Available in Kernel 6.12 or newer)
    # https://github.com/sched-ext/scx
    # https://www.kernel.org/doc/html/next/scheduler/sched-ext.html
    # https://wiki.cachyos.org/configuration/sched-ext/
    scx.full
  ];

  # services.sunshine = {
  #     enable = true;
  #     openFirewall = true;
  #     capSysAdmin = true;
  # };

  # ------------ Flatpak ------------

  services.flatpak.packages = [
    "com.parsecgaming.parsec"
  ];

  programs = {
    # Steam locations that should be persistent:
    #   ~/.local/share/Steam                  - Default Steam install location
    #   ~/.local/share/Steam/steamapps/common - Default Game install location
    #   ~/.steam/root                         - Symlink to `~/.local/share/Steam`
    #   ~/.steam                              - Some Symlinks & user info
    steam = {
      enable = true;
      protontricks.enable = true; # Simple wrapper for running Winetricks commands for Proton-enabled games
      gamescopeSession.enable = true; # Enable GameScope Session
      remotePlay.openFirewall = true; # Ports for Steam Remote Play
      localNetworkGameTransfers.openFirewall = true; # Ports for Steam Local Network Game Transfers
      # dedicatedServer.openFirewall = true;          # Ports for Source Dedicated Server
    };

    # Optimise system performance on demand
    gamemode.enable = true;
  };

  # Improve compatibility with memory hungry applications (e.g. games)
  boot.kernel.sysctl."vm.max_map_count" = 1048576;
}
