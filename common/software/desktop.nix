{ inputs, pkgs, ... }:

{
  # ------------ Nixpkgs ------------

  environment.systemPackages = with pkgs; [
    # Applications
    mpv # Video Player
    mpvScripts.thumbnail # Lua script to show preview thumbnails in mpv's OSC seekbar
    mpvScripts.thumbfast # High-performance on-the-fly thumbnailer for mpv
    mpvScripts.uosc # Feature-rich minimalist proximity-based UI for MPV player

    brave # Web Browser
    firefox # Web Browser
    spotify # Music Streaming
    syncplay # Synchronise Media Players
    obsidian # Note Taking
    gearlever # AppImage Manager
    argyllcms # Colour Managment System
    ente-auth # 2FA
    displaycal # Display Calibration Tool
    # trackma-qt                    # AniList Client / Currently broken - ISSUE: https://github.com/NixOS/nixpkgs/issues/377206
    microsoft-edge # Web Browser
    github-desktop # Github Client
    gimp # Image Manipulation Program
    simplescreenrecorder # Screen Recorder
    inkscape-with-extensions # Vector Graphics Editor
    libreoffice-qt6-fresh # Office Suite
    mailspring # Email Client

    # Disk Utilities
    kdiskmark # HDD / SSD Benchmark Tool
    f3 # Tests flash cards capacity / performance to see if they live up to claimed specifications

    # Peripherals
    solaar # Linux device manager for Logitech devices
    vial # Keyboard Firmware Manager
    jamesdsp # Audio effect processor for PipeWire clients (EQ for Headphones) ISSUE: ??? Currently not building
    qpwgraph # Qt graph manager for PipeWire
    #naps2 # Document Scanning / ISSUE: https://github.com/NixOS/nixpkgs/issues/326335

    # KDE Applications (QT)
    #krita # Digital Painting
    #krita-plugin-gmic # Image Processing Plugin
    kdePackages.kate # Text / Code Editor
    kdePackages.kalk # Calculator
    kdePackages.elisa # Music Player
    kdePackages.kclock # Clock
    kdePackages.kweather # Weather
    kdePackages.filelight # Quickly visualize your disk space usage
    kdePackages.kde-gtk-config # Syncs KDE settings to GTK applications
    kdePackages.partitionmanager # Manage disks, partitions and file systems

    fooyin # Music Player

    kdePackages.sonnet # Spelling framework for Qt
    aspell # Spell Checker
    aspellDicts.en # English dictionary
    aspellDicts.en-science # English Scientific Jargon dictionary
    aspellDicts.en-computers # English Computer Jargon dictionary
    aspellDicts.pl # Polish dictionary

    wineWowPackages.stagingFull # Run Windows Apps on Linux
    winetricks # Script to install DLLs needed to work around problems in Wine

    discord-krisp

    inputs.tagstudio.packages.${pkgs.stdenv.hostPlatform.system}.tagstudio
  ];

  # ------------ Excludes ------------

  services.xserver.excludePackages = [ pkgs.xterm ];

  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/plasma6.nix#L135
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    khelpcenter # Help app
    krdp # Remove Desktop (RDP)
    discover # Software Store
  ];

  # Redirects the MailSpring update URL to prevent the update notification.
  networking.extraHosts = ''
    127.0.0.1 updates.getmailspring.com
  '';

  # ------------ Programs with Daemons ------------

  programs = {
    kde-pim.enable = false; # Used for Kontact / Kmail
    #coolercontrol.enable = true; # Cooling Device Control
    gnupg.agent.enable = true; # GNU Privacy Guard, a GPL OpenPGP implementation
    adb.enable = true; # Android Debug Bridge (ADB)
  };

  # ------------ Flatpak ------------

  services.flatpak = {
    enable = true;
    update = {
      onActivation = true;
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];

    packages = [
      {
        appId = "com.discordapp.DiscordCanary";
        origin = "flathub-beta";
      }
      #"com.discordapp.Discord" # Requires XDG_SESSION_TYPE=x11 for screensharing to work.
      #"dev.vencord.Vesktop" # Discord Client
      "org.gitfourchette.gitfourchette" # Git Client
      "io.github.giantpinkrobots.bootqt" # Bootable Image -> USB Creator
      #"me.timschneeberger.jdsp4linux" # JamesDSP
    ];
  };

  # ------------ AppImage ------------

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
