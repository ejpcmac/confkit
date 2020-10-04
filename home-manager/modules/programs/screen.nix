####### Configuration for screen ###############################################
##                                                                            ##
## * Set the termcapinfo for usage as serial console                          ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.confkit.programs.screen;
in

{
  options.confkit.programs.screen = {
    enable = mkEnableOption "the confkit home configuration for screen";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.screen ];
    home.file.".screenrc".source = ../../../misc/screenrc;
  };
}
