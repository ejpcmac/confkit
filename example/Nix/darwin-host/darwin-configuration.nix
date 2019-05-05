################################################################################
##                                                                            ##
##                    System configuration for darwin-host                    ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

let
  confkit = import ../../confkit;
in

{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  imports = with confkit.modules; [
    environment
    nix
    tmux
    vim
    zsh
  ];

  nix.maxJobs = 4;

  environment.variables = {
    LANG = "fr_FR.UTF-8";
    LC_ALL = "$LANG";
  };

  environment.systemPackages = with pkgs; [
    coreutils
    curl
    dcfldd
    emv
    git
    git-lfs
    iftop
    imagemagick
    lsof
    nix-prefetch-github
    nox
    openssh
    rename
    rsync
    testdisk
    tree
    unzip
    watch
    wget
    xz
    zip
  ];

  services = {
    nix-daemon.enable = true;
  };
}
