{
  file = f: ./. + "/${f}";

  # TODO: Generate automatically.
  modules = {
    system = {
      environment = ./Nix/system/environment.nix;
      nix = ./Nix/system/nix.nix;
      tmux = ./Nix/system/tmux.nix;
      utilities = ./Nix/system/utilities.nix;
      vim = ./Nix/system/vim.nix;
      zsh = ./Nix/system/zsh.nix;
    };

    user = {
      git = ./Nix/user/git.nix;
      root = ./Nix/user/root.nix;
    };
  };
}
