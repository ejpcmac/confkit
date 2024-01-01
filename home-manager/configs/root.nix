####### Home configuration for root users ######################################
##                                                                            ##
## * Use Zsh                                                                  ##
## * Include custom Nix aliases (see `../zsh/nix.zsh`)                        ##
##                                                                            ##
################################################################################

{
  imports = [ ./.. ];

  home.stateVersion = "23.11";

  confkit.programs.zsh = {
    enable = true;
    plugins = [ "aliases" "nix" ];
  };

  programs.home-manager = {
    enable = true;
  };
}
