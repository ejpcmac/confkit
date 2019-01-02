##
## Home configuration for user@linux-host
##

{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkForce;
  confkit = import ../../confkit;
in

{
  imports = [ ../common/home.nix ];

  home.packages = with pkgs; [
    # Packages normally installed system-wide. Since we are on a single-user
    # install, we install them user-wide.
    curl
    dcfldd
    docker
    docker_compose
    emv
    git-lfs
    gnupg
    htop
    iftop
    imagemagick
    nix-prefetch-github
    nox
    openssh
    rsync
    tokei
    wget
    xz

    # signal-desktop
  ];

  home.file = {
    # linux-host-specific config
    # ".zsh/fedora.zsh".source = confkit.file "zsh/fedora.zsh";
    # ".zsh/gpg-agent.zsh".source = confkit.file "zsh/gpg-agent.zsh";
  };

  # Specific Git configuration
  programs.git = {
    extraConfig.credential.helper = "store";
  };

  # Enable Vim here since the system configuration is not handled.
  programs.vim = {
    enable = true;
    extraConfig = readFile (confkit.file "/vim/vimrc")
      + readFile (confkit.file "vim/colors/wellsokai.vim");
  };

  programs.zsh = {
    initExtra = mkForce (''
      if [ -z "$IN_NIX_SHELL" ]; then
          source $HOME/.nix-profile/etc/profile.d/nix.sh
          export NIX_PATH=$NIX_PATH:$HOME/.nix-defexpr/channels
      fi
    '' + readFile (confkit.file "zsh/config/home_init.zsh"));

    # Add nix because auto-completion does not work out of the box on non NixOS
    # or nix-darwin platform for now.
    oh-my-zsh.plugins = [ "nix" ];
  };
}
