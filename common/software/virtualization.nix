{ userSettings, ... }:

{
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    users.users.${userSettings.username}.extraGroups = [ "libvirtd" ];

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