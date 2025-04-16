####### Configuration for GPG ##################################################
##                                                                            ##
## * Configure the default key from confkit.identity                          ##
## * Always ask level and expiration when certifying a key                    ##
## * Configure the keyserver                                                  ##
## * Automatically retrieve keys                                              ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.confkit.programs.gpg;
  identity = config.confkit.identity;
in

{
  options.confkit.programs.gpg = {
    enable = mkEnableOption "the confkit home configuration for GPG";
  };

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;

      settings = {
        default-key = mkDefault identity.gpgKey;
        ask-cert-level = mkDefault true;
        ask-cert-expire = mkDefault true;
        keyserver = mkDefault "hkps://keys.openpgp.org";
      };

      scdaemonSettings = {
        # This allows GPG to work with PC/SC.
        disable-ccid = mkDefault true;
      };
    };
  };
}
