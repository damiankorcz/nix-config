{ lib, pkgs, userSettings, ... }:

{
    # For mount.cifs, required unless domain name resolution is not needed.
    environment.systemPackages = [ pkgs.cifs-utils ];

    fileSystems."/mnt/pi4" = {
        device = "//192.168.50.16/Pi4";
        fsType = "cifs";
        options = [
            "credentials=/home/${userSettings.username}/.config/samba/smb-secrets"
            "x-systemd.automount"
            "noauto"
            "x-systemd.idle-timeout=60"
            "x-systemd.device-timeout=5s"
            "x-systemd.mount-timeout=5s"
            "uid=1000"
            "gid=1000"
        ];
    };
}
