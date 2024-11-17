{ pkgs, inputs, ... }:

{
  # your other configurations
  imports = [
    (import "${inputs.xppen-pr}/nixos/modules/programs/xppen.nix")
  ];

  programs.xppen = {
    enable = true;
    package = (import inputs.xppen-pr { }).xppen_3;
  };
}