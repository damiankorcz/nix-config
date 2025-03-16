{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mangohud # Vulkan / OpenGL Overlay for System Monitoring and FPS
    lutris # Open Source Gaming Platform
    protonup-qt # Install / Manage Proton-GE & Luxtorpeda for Steam / Wine-GE for Lutris
    protonplus
    libnotify # Library for Sending Desktop Notifications to the Notification Daemon
    prismlauncher # Launcher for Minecraft

    vulkan-tools # Khronos official Vulkan Tools and Utilities
    inxi
    #moonlight-qt    # Play your PC games on almost any device

    # Sched-ext userspace Schedulers (Available in Kernel 6.12 or newer)
    # https://github.com/sched-ext/scx
    # https://www.kernel.org/doc/html/next/scheduler/sched-ext.html
    # https://wiki.cachyos.org/configuration/sched-ext/
    scx.full

    lact
  ];

  # programs.corectrl = {
  #   enable = true;
  #   gpuOverclock = {
  #     enable = true;
  #     ppfeaturemask = "0xfffd3fff"; # 0xffffffff
  #   };
  # };

  # Enable the AMDGPU Control Daemon
  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };

  chaotic = {
    mesa-git = {
      enable = true;
      extraPackages = [ pkgs.amdvlk ]; # pkgs.rocmPackages.clr.icd
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
    nyx.cache.enable = true;
  };

  hardware.firmware = with pkgs; [
    (linux-firmware.overrideAttrs (old: {
      src = builtins.fetchGit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        # rev = "de78f0aaafb96b3a47c92e9a47485a9509c51093"; # Uncomment this line to allow for pure builds
      };
    }))
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
