################################################################################
##                                                                            ##
##                   Home configuration for user@nixos-host                   ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  home.stateVersion = "22.11"; # Did you read the comment?

  # Import the confkit home-manager module to get ready-to-use configurations
  # for several tools.
  imports = [ ../../../../confkit/home-manager ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    # keyoard.layout = "bépo";

    identity = {
      # TODO: Update your information.
      name = "John Doe";
      email = "john.doe@example.com";
      # gpgKey = "<some fpr>";
    };

    programs = {
      git.enable = true;
      # gpg.enable = true;
      # screen.enable = true;

      zsh = {
        enable = true;
        plugins = [
          "aliases"
          # "asdf"
          # "ceedling"
          # "dev"
          # "direnv"
          # "django"
          # "docker"
          # "elixir"
          "git"
          # "haskell"
          # "imagemagick"
          "nix"
          # "ocaml"
          # "rust"
          # "xen"
          # "zfs"
        ];
      };
    };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    home-manager.enable = true;

    zsh = {
      oh-my-zsh.plugins = [
        "git"
        "git-flow"
        "zsh-syntax-highlighting"
      ];

      # shellAliases = {
      #   tmux = "direnv exec / tmux";
      # };
    };
  };

  ############################################################################
  ##                             User packages                              ##
  ############################################################################

  home.packages = with pkgs; [
    bashInteractive
    # direnv
  ];
}
