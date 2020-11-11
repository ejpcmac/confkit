####### Configuration for Intel processors #####################################
##                                                                            ##
## * Enable microcode update                                                  ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.confkit.features.intel;
in

{
  options.confkit.features.intel = {
    enable = mkEnableOption "configuration for intel processors";
  };

  config = lib.mkIf cfg.enable {
    hardware.cpu.intel.updateMicrocode = true;
  };
}
