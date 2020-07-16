####### Configuration for the identity #########################################
##                                                                            ##
## This module provides a way to gather information about user’s identity.    ##
## This information can then be used in other confkit modules or in the       ##
## user’s configuration.                                                      ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
in

{
  options.confkit.identity = {
    name = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "John Doe";
      description = "Your name.";
    };

    email = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "john.doe@example.com";
      description = "Your email.";
    };

    gpgKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Your GPG Key fingerprint.";
    };
  };
}
