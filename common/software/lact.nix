{ pkgs, inputs, ... }:

{
  # Temp fix before this is merged: https://github.com/NixOS/nixpkgs/pull/374771
  imports = [
    (import "${inputs.lact-pr}pkgs/by-name/la/lact/package.nix")
  ];

  environment.systemPackages = [
    (import inputs.lact-pr {
      inherit (pkgs) system;
    }).lact
  ];

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
    enable = true;
  };
}
