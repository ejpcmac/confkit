####### Home configuration for root users ######################################
##                                                                            ##
## * Use Zsh                                                                  ##
## * Include custom Nix aliases (see `../zsh/nix.zsh`)                        ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  imports = [ ./.. ];

  home.stateVersion = "22.05";

  confkit.programs.zsh = {
    enable = true;
    plugins = [ "aliases" "nix" ];
  };

  programs.home-manager = {
    enable = true;
  };
}
