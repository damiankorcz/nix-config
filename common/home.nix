{ userSettings, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    uid = 1000;
    isNormalUser = true;
    description = userSettings.name;
    initialPassword = "changeme";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "kvm"
      "video"
    ];
  };

  environment = {
    # Set environment variables
    variables = {
      EDITOR = userSettings.editor;
      SPAWNEDITOR = userSettings.spawnEditor;
      TERM = userSettings.terminal;
      BROWSER = userSettings.browser;
    };

    # Configure XDG user directories
    etc."xdg/user-dirs.conf".text = ''
      XDG_MUSIC_DIR="/home/${userSettings.username}/Media/Music"
      XDG_VIDEOS_DIR="/home/${userSettings.username}/Media/Videos"
      XDG_PICTURES_DIR="/home/${userSettings.username}/Media/Pictures"
      XDG_DOWNLOAD_DIR="/home/${userSettings.username}/Downloads"
      XDG_DOCUMENTS_DIR="/home/${userSettings.username}/Documents"
      XDG_DESKTOP_DIR="/home/${userSettings.username}/Desktop"
      XDG_DOTFILES_DIR="/home/${userSettings.username}/.dotfiles"
      XDG_VM_DIR="/home/${userSettings.username}/VMs"
    '';
  };

  # Enable Git
  programs.git = {
    enable = true;
    config = {
      user.name = userSettings.name;
      user.email = userSettings.email;
      init.defaultBranch = "main";
      safe.directory = [
        "/etc/nixos"
        "/home/${userSettings.username}"
      ];
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  };
}
