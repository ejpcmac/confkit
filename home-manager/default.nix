{
  imports = [
    ../common/keyboard.nix

    ./modules/identity.nix

    ./modules/programs/git.nix
    ./modules/programs/gpg.nix
    ./modules/programs/pms.nix
    ./modules/programs/screen.nix
    ./modules/programs/tridactyl.nix
    ./modules/programs/zathura.nix
    ./modules/programs/zsh.nix
  ];
}
