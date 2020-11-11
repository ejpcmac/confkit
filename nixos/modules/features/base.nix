####### Base configuration #####################################################
##                                                                            ##
## * Make users immutable                                                     ##
## * Use Zsh as default shell                                                 ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.confkit.features.base;
in

{
  options.confkit.features.base = {
    enable = mkEnableOption "the base configuration from confkit";
  };

  config = mkIf cfg.enable {
    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.zsh;
    };
  };
}
