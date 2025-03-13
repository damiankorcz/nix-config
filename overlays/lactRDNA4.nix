final: prev: {
  lact = prev.lact.overrideAttrs (oldAttrs: {
    src = builtins.fetchGit {
      url = "https://github.com/ilya-zlobintsev/LACT";
      ref = "feature/rdna4"; # Branch you want to use
      # Optional: Uncomment and specify a commit hash for reproducibility
      # rev = "commit-hash";
    };
  });
}
