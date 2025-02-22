{ pkgs, inputs, ... }:

{
    # Temp fix before this is merged: https://github.com/NixOS/nixpkgs/pull/351647
    imports = [
        (import "${inputs.xppen-pr}/nixos/modules/programs/xppen.nix")
    ];

    programs.xppen = {
        enable = true;
        package = (import inputs.xppen-pr { inherit (pkgs) system; config.allowUnfree = true; }).xppen_4;
    };
}
