{ pkgs, ... }:

{
    # ------------ Nixpkgs ------------

    environment.systemPackages = with pkgs; [
        vscode      # Code Editor
        zed-editor  # Code Editor

        # Development Dependencies
        pnpm        # Fast, disk space efficient package manager for JavaScript
        nodejs_20   # JavaScript runtime environment (20 is latest compatible with pnpm)
        python313   # Python 3.13
        nixd        # Nix language server
        nil         # Nix language server (Required by Zed)

        imhex       # Hex Editor
    ];
}
