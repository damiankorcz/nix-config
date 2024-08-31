{ lib, pkgs, ... }:

{
    # For mount.cifs, required unless domain name resolution is not needed.
    environment.systemPackages = [ pkgs.cifs-utils ];

    fileSystems."/mnt/pi4" = {
        device = "//192.168.50.16/Pi4";
        fsType = "cifs";
        options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

        in ["${automount_opts},credentials=~/.config/samba/smb-secrets"];
    };

    # https://discourse.nixos.org/t/cant-mount-samba-share-as-a-user/49171/3
    security.wrappers."mount.cifs" = {
      program = "mount.cifs";
      source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
      owner = "root";
      group = "root";
      setuid = true;
    };
}
