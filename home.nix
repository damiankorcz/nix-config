{ config, pkgs, userSettings,  ... }:

{
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${userSettings.username} = {
        isNormalUser = true;
        description = userSettings.name;
        extraGroups = [ "networkmanager" "wheel" ];
        uid = 1000;
    };

    home-manager.users.${userSettings.username} =  { pkgs, ... }: {
        home.stateVersion = "24.05";

        home.username = userSettings.username;
        home.homeDirectory = "/home/"+userSettings.username;

        home.sessionVariables = {
            EDITOR = userSettings.editor;
            SPAWNEDITOR = userSettings.spawnEditor;
            TERM = userSettings.terminal;
            BROWSER = userSettings.browser;
        };

        xdg.userDirs = {
            enable = true;
            createDirectories = true;
            music = "/home/${userSettings.username}/Media/Music";
            videos = "/home/${userSettings.username}/Media/Videos";
            pictures = "/home/${userSettings.username}/Media/Pictures";
            download = "/home/${userSettings.username}/Downloads";
            documents = "/home/${userSettings.username}/Documents";
            desktop = "/home/${userSettings.username}/Desktop";

            extraConfig = {
                XDG_DOTFILES_DIR = "/home/${userSettings.username}/.dotfiles";
                XDG_VM_DIR = "/home/${userSettings.username}/VMs";
            };
        };

        # Enable Git
        programs = {
            git = {
                enable = true;
                lfs.enable = true;
                userName  = userSettings.name;
                userEmail = userSettings.email;
                extraConfig = {
                    init.defaultBranch = "main";
                    safe.directory = [
                    "/etc/nixos"
                    "/home/${userSettings.username}"
                    ];
                };
            };
        };
    };

    services = {
        displayManager = {
            # Enable automatic login for the user.
            autoLogin.enable = true;
            autoLogin.user = userSettings.username;

            # Declares default session (Wayland = plasma / X11 = plasmax11)
            defaultSession = userSettings.defaultSession;

            # Enable Display Manager for Plasma.
            sddm = {
                enable = true;
                wayland.enable = true;
            };
        };

        # Enable the KDE Plasma Desktop Environment.
        desktopManager.plasma6.enable = true;

        # Enable the X11 windowing system.
        # You can disable this if you're only using the Wayland session.
        # xserver.enable = true;
    };
}
