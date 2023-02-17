####### Base configuration #####################################################
##                                                                            ##
## * Make users immutable                                                     ##
## * Use Zsh as default shell                                                 ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.confkit.features.base;
in

{
  options.confkit.features.base = {
    enable = mkEnableOption "the base configuration from confkit";
  };

  config = mkIf cfg.enable {
    users = {
      mutableUsers = mkDefault false;
      defaultUserShell = pkgs.zsh;
    };
  };
}
