{ pkgs, userSettings, ... }:

{
    # ------------ Virt Manager ------------

    virtualisation.libvirtd = {
        enable = true;

        qemu = {
            package = pkgs.qemu_kvm;
            
            ovmf = {
                enable = true;
                packages = [pkgs.OVMFFull.fd];
            };
            
            swtpm.enable = true;
        };
    };

    programs.virt-manager.enable = true;

    users.users.${userSettings.username}.extraGroups = [ "libvirtd" ];

    # ------------ Distrobox ------------

    virtualisation.podman = {
        enable = true;
        dockerCompat = true;
    };

    environment.systemPackages = [ pkgs.distrobox ];

    # For Windows as a Guest:
    # https://github.com/virtio-win/virtio-win-guest-tools-installer

    # For NixOS as a Guest:
    # services.qemuGuest.enable = true;
    # services.spice-vdagentd.enable = true;  # enable copy and paste between host and guest

    # Need to enable networking with:
    # virsh net-start default
    #
    # Or autostart:
    # virsh net-autostart default

    # https://nixos.wiki/wiki/Virt-manager
    #     dconf.settings = {
    #         "org/virt-manager/virt-manager/connections" = {
    #             autoconnect = ["qemu:///system"];
    #             uris = ["qemu:///system"];
    #         };
    #     };
}