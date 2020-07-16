####### Configuration for the identity #########################################
##                                                                            ##
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
      description = "Your name";
    };

    email = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "john.doe@example.com";
      description = "Your email";
    };

    gpgKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Your GPG Key fingerprint";
    };
  };
}
