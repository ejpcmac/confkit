####### Home configuration for root users ######################################
##                                                                            ##
## * Use Zsh                                                                  ##
## * Include custom Nix aliases (see `../zsh/nix.zsh`)                        ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  imports = [ ./.. ];

  confkit.zsh = {
    enable = true;
    plugins = [ "aliases" "nix" ];
  };

  programs.home-manager = {
    enable = true;
  };
}
