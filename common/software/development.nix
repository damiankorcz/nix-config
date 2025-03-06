{ pkgs, ... }:

{
  # ------------ Nixpkgs ------------

  environment.systemPackages = with pkgs; [
    # Development Tools
    vscode # Code Editor
    #zed-editor  # Code Editor
    imhex # Hex Editor

    # Development Dependencies
    pnpm # Fast, disk space efficient package manager for JavaScript
    nodejs_20 # JavaScript runtime environment (20 is latest compatible with pnpm)
    nixd # Nix language server
    nil # Nix language server (Required by Zed)
    gnumake
    qmk # Keyboard Firmware
    qmk-udev-rules # Udev rules for QMK devices
    dfu-util # USB Programmer
    i2c-tools

  ];
}
