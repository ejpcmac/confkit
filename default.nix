{
  file = f: ./. + "/${f}";

  # TODO: Generate automatically.
  modules = {
    environment = ./Nix/environment.nix;
    git = ./Nix/git.nix;
    nix = ./Nix/nix.nix;
    root = ./Nix/root.nix;
    tmux = ./Nix/tmux.nix;
    vim = ./Nix/vim.nix;
    zsh = ./Nix/zsh.nix;
  };
}
