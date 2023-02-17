####### Configuration for GPG ##################################################
##                                                                            ##
## * Configure the default key from confkit.identity                          ##
## * Always ask level and expiration when certifying a key                    ##
## * Configure the keyserver                                                  ##
## * Automatically retreive keys                                              ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault;
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
        keyserver-options = mkDefault "no-honor-keyserver-url auto-key-retrieve";
        keyserver = mkDefault "hkps://hkps.pool.sks-keyservers.net";
      };
    };
  };
}
