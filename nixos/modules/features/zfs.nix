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

    ########################################################################
    ##                           Shell aliases                            ##
    ########################################################################

    environment.shellAliases = {
      disable-zfs-snapshots = ''
        sudo systemctl stop zfs-snapshot-frequent.timer && \
        sudo systemctl stop zfs-snapshot-hourly.timer && \
        sudo systemctl stop zfs-snapshot-daily.timer && \
        sudo systemctl stop zfs-snapshot-weekly.timer && \
        sudo systemctl stop zfs-snapshot-monthly.timer
      '';

      enable-zfs-snapshots = ''
        sudo systemctl start zfs-snapshot-frequent.timer && \
        sudo systemctl start zfs-snapshot-hourly.timer && \
        sudo systemctl start zfs-snapshot-daily.timer && \
        sudo systemctl start zfs-snapshot-weekly.timer && \
        sudo systemctl start zfs-snapshot-monthly.timer
      '';
    };
  };
}
