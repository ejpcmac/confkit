####### Home configuration for root users ######################################
##                                                                            ##
## * Use Zsh                                                                  ##
## * Include custom Nix aliases (see `../zsh/nix.zsh`)                        ##
## * Sources `/etc/zprofile` in case it has not been sourced before           ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  home.file = {
    # Zsh aliases and environments
    ".zsh/aliases.zsh".source = ../zsh/aliases.zsh;
    ".zsh/nix.zsh".source = ../zsh/nix.zsh;
  };

  programs.home-manager = {
    enable = true;
  };

  programs.zsh = {
    enable = true;

    initExtra = ''
      source /etc/zprofile
      for script ($HOME/.zsh/*.zsh); do
        source $script
      done
      unset script
    '';
  };
}
