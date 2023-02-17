####### Configuration for the identity #########################################
##                                                                            ##
## This module provides a way to gather information about user’s identity.    ##
## This information can then be used in other confkit modules or in the       ##
## user’s configuration.                                                      ##
##                                                                            ##
################################################################################

{ lib, ... }:

let
  inherit (lib) mkOption;
  inherit (lib.types) nullOr str;
in

{
  options.confkit.identity = {
    name = mkOption {
      type = nullOr str;
      default = null;
      example = "John Doe";
      description = "Your name.";
    };

    email = mkOption {
      type = nullOr str;
      default = null;
      example = "john.doe@example.com";
      description = "Your email.";
    };

    gpgKey = mkOption {
      type = nullOr str;
      default = null;
      description = "Your GPG Key fingerprint.";
    };
  };
}
