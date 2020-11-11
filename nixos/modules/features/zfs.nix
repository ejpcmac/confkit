####### Configuration for the ZFS feature ######################################
##                                                                            ##
## * Enable autoscrub and autosnapshot                                        ##
## * Install sanoid                                                           ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.confkit.features.zfs;
in

{
  options.confkit.features.zfs = {
    enable = mkEnableOption "configuration for ZFS";
  };

  config = mkIf cfg.enable {

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      zfs = {
        autoSnapshot.enable = mkDefault true;
        autoScrub.enable = mkDefault true;
      };
    };

    ########################################################################
    ##                          System packages                           ##
    ########################################################################

    environment.systemPackages = [ pkgs.sanoid ];
  };
}
