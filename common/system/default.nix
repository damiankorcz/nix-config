{ pkgs, ... }:

{
  # ------------ Bootloader ------------

  boot = {
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];

    # Filesystem support
    supportedFilesystems = [
      "ntfs"
      "btrfs"
    ];

    # Boot Splash Screen
    # plymouth.enable = true;

    # Bandaid for LVM warnings on boot
    # https://github.com/NixOS/nixpkgs/issues/342082#issuecomment-2384783512
    initrd.preLVMCommands = ''
      export LVM_SUPPRESS_FD_WARNINGS=1
    '';
  };

  systemd.extraConfig = ''DefaultTimeoutStopSec=10s'';
  systemd.user.extraConfig = ''DefaultTimeoutStopSec=10s'';

  # ------------ Cleanup ------------

  nix = {
    # Optimisation of the Nix Store
    optimise.automatic = true;
    optimise.dates = [ "weekly" ];

    # Garbage colection (Removes Old Snapshots)
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    channel.enable = false;

    # Increase download buffer size
    settings.download-buffer-size = 524288000; # 500 MB buffer size
  };

  # Recomputes checksums and compares to current to detect corruption
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  # ------------ Timezone & Locale ------------

  # Set your time zone
  time.timeZone = "Europe/London";

  # Select internationalisation properties
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.supportedLocales = [ "all" ];

  # ------------ Fonts ------------

  fonts = {
    # Links all fonts to: `/run/current-system/sw/share/X11/font`
    fontDir.enable = true;

    packages = with pkgs; [
      font-awesome
      noto-fonts
      noto-fonts-emoji
      source-sans
      source-serif
      corefonts
      vistafonts
      ubuntu-sans
      cascadia-code

      # Nerdfonts
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.geist-mono
      nerd-fonts.blex-mono
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      nerd-fonts.sauce-code-pro
      nerd-fonts.ubuntu-mono
    ];
  };

  # ------------ Networking ------------

  networking = {
    networkmanager.enable = true;

    # Open ports in the firewall.
    #firewall {
    # allowedTCPPorts = [ ... ];
    # allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # enable = false;
    #}
  };

  # ------------ Hardware ------------

  hardware = {
    enableAllFirmware = true;

    logitech.wireless.enable = true;

    graphics = {
      enable = true;

      # Vulkan support for 32bit programs
      enable32Bit = true;

      ## amdvlk: an open-source Vulkan driver from AMD. Otherwise RADV is used.
      # extraPackages = [ pkgs.amdvlk ];
      # extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };

    # amdgpu.amdvlk = {
    #   enable = true;
    #   support32Bit.enable = true;
    #   supportExperimental.enable = true;
    # };
  };

  # ------------ Services ------------

  services = {
    # Enable Linux Vendor Firmware Service
    fwupd.enable = true;

    # Daemon to configure input devices, mainly gaming mice (Paired with Piper)
    ratbagd.enable = true;

    # Enable the OpenSSH daemon
    openssh.enable = true;
    openssh.settings.PasswordAuthentication = true;
    openssh.settings.PermitRootLogin = "no";
  };
}
