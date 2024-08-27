{ config, pkgs, userSettings, ... }:

{
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${userSettings.username} = {
        uid = 1000;
        isNormalUser = true;
        description = userSettings.name;
        initialHashedPassword = "changeme";
        extraGroups = [ "networkmanager" "wheel" ];
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
}
