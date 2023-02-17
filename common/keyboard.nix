####### Configuration for the keyboard #########################################
##                                                                            ##
## This module gathers information about keyboard preferences. It can then be ##
## used in other confkit modules or in the user’s configuration.              ##
##                                                                            ##
################################################################################

{ lib, ... }:

let
  inherit (lib) mkOption;
  inherit (lib.types) enum;
  layouts = enum [ null "bépo" ];
in

{
  options.confkit.keyboard = {
    layout = mkOption {
      type = layouts;
      default = null;
      example = "bépo";
      description = ''
        The keyboard layout to use for keybindings optimisation.
      '';
    };
  };
}
