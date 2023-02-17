####### Configuration for Intel processors #####################################
##                                                                            ##
## * Enable microcode update                                                  ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.confkit.features.intel;
in

{
  options.confkit.features.intel = {
    enable = mkEnableOption "configuration for intel processors";
  };

  config = mkIf cfg.enable {
    hardware.cpu.intel.updateMicrocode = true;
  };
}
