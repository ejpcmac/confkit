####### Home configuration for root users ######################################
##                                                                            ##
## * Use Zsh and Oh My Zsh                                                    ##
## * Use a custom “Bazik” theme                                               ##
## * Include `git` and `zsh-syntax-highlighting` plugins                      ##
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

    # Zsh themes
    ".zsh-custom/themes/bazik.zsh-theme".source = ../zsh/themes/bazik.zsh-theme;
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

    oh-my-zsh = {
      enable = true;

      custom = "$HOME/.zsh-custom";
      theme = "bazik";
      plugins = [ "git" "zsh-syntax-highlighting" ];
    };
  };
}
