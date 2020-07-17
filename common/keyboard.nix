####### Configuration for the keyboard #########################################
##                                                                            ##
## This module gathers information about keyboard preferences. It can then be ##
## used in other confkit modules or in the user’s configuration.              ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
in

{
  options.confkit.keyboard = {
    bepo = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Wether to use keybindings optimised for BÉPO keyboards by default.
      '';
    };
  };
}
