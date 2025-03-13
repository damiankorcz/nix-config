{
  description = "Custom lact package using a specific Git branch";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/unstable"; # Use unstable nixpkgs

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux"; # Adjust this based on your system architecture
        overlays = [
          (final: prev: {
            lact = prev.lact.overrideAttrs (oldAttrs: {
              src = builtins.fetchGit {
                url = "https://github.com/ilya-zlobintsev/LACT";
                ref = "feature/rdna4"; # Branch you want to use
                # Optional: Uncomment and provide a specific commit hash for reproducibility
                # rev = "commit-hash";
              };
            });
          })
        ];
      };
    in
    {
      defaultPackage.x86_64-linux = pkgs.lact; # Specify the default package if needed
    };
}
