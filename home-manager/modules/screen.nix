####### Configuration for screen ###############################################
##                                                                            ##
## * Set the termcapinfo for usage as serial console                          ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.confkit.screen;
in

{
  options.confkit.screen = {
    enable = mkEnableOption "the confkit home configuration for screen";
  };

  config = mkIf cfg.enable {
    home.file.".screenrc".source = ../../misc/screenrc;
  };
}
