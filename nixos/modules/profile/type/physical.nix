####### Configuration profile for physical machines ############################
##                                                                            ##
## * Enable Chrony and smartd                                                 ##
## * Update the CPU microcode when the intel feature is enabled               ##
## * Install lm_sensors                                                       ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkDefault;

  fs = config.confkit.features.fileSystems;
  mkFs = pkgs.lib.confkit.mkFs config;
in

{
  config = mkIf (builtins.elem "physical" config.confkit.profile.type) {

    ########################################################################
    ##                            File systems                            ##
    ########################################################################

    fileSystems = mkIf (fs.enable && fs.rootOnTmpfs) {
      "/persist/chrony" = mkFs { volumePath = "/system/data/chrony"; };
    };

    ########################################################################
    ##                            Persistence                             ##
    ########################################################################

    systemd.tmpfiles.rules = mkIf fs.rootOnTmpfs [
      "z /persist/chrony 755 chrony chrony - -"
      "L+ /var/lib/chrony - - - - /persist/chrony"
    ];

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      chrony.enable = mkDefault true;
      smartd.enable = mkDefault true;
    };

    ########################################################################
    ##                          System packages                           ##
    ########################################################################

    environment.systemPackages = with pkgs; [
      # Utilities
      lm_sensors
    ];
  };
}
