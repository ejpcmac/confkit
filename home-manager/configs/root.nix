####### Home configuration for root users ######################################
##                                                                            ##
## * Use Zsh                                                                  ##
## * Use eza and dua instead of ls and du                                     ##
## * Include custom Nix aliases (see `../zsh/nix.zsh`)                        ##
##                                                                            ##
################################################################################

{
  imports = [ ./.. ];

  home.stateVersion = "23.11";

  confkit.programs = {
    dua.enable = true;
    eza.enable = true;

    zsh = {
      enable = true;
      plugins = [ "aliases" "nix" ];
    };
  };

  programs.home-manager = {
    enable = true;
  };
}
