{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lact

    # Benchmarks
    unigine-superposition
    furmark
  ];

  # programs.corectrl = {
  #   enable = true;
  #   gpuOverclock = {
  #     enable = true;
  #     ppfeaturemask = "0xfffd3fff"; # 0xffffffff
  #   };
  # };

  # Enable the LACT Daemon
  systemd.services.lact = {
    description = "LACT Daemon";
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
      # extraPackages = [ pkgs.amdvlk ]; # pkgs.rocmPackages.clr.icd
      # extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
    nyx.cache.enable = true;
  };

  # hardware.firmware = with pkgs; [
  #   (linux-firmware.overrideAttrs (old: {
  #     src = builtins.fetchGit {
  #       url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
  #       # rev = "de78f0aaafb96b3a47c92e9a47485a9509c51093"; # Uncomment this line to allow for pure builds
  #     };
  #   }))
  # ];
}
