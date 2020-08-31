{
  imports = [
    ../common/keyboard.nix

    ./modules/features/fonts.nix
    ./modules/features/shell.nix
    ./modules/features/utilities.nix

    ./modules/programs/nix.nix
    ./modules/programs/ranger.nix
    ./modules/programs/tmux.nix
    ./modules/programs/vim.nix
    ./modules/programs/zsh.nix
  ];
}
