####### Configuration for Git ##################################################
##                                                                            ##
## * Configure the user information from confkit.identity                     ##
## * Sign by default (including git-flow) when confkit.gpg is enabled         ##
## * Always create a merge commit by default (including gitflow)              ##
## * Rebase on pull, preserving previous merge commits                        ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkDefault types;
  cfg = config.confkit.git;
  identity = config.confkit.identity;
in

{
  options.confkit.git = {
    enable = mkEnableOption "the confkit home configuration for Git";

    gpgSign = mkOption {
      type = types.bool;
      default = config.confkit.gpg.enable;
      example = true;
      description = ''
        Wether to sign commits with GPG. This defaults to true when the confkit
        GPG module is enabled.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      userName = mkDefault identity.name;
      userEmail = mkDefault identity.email;

      signing = mkIf cfg.gpgSign {
        gpgPath = mkDefault "gpg2";
        key = mkDefault identity.gpgKey;
        signByDefault = mkDefault true;
      };

      extraConfig = {
        merge.ff = mkDefault false;
        pull.rebase = mkDefault "preserve";
        mergetool.keepBackup = mkDefault false;

        "gitflow \"feature.finish\"".no-ff = mkDefault true;
        "gitflow \"release.finish\"".sign = mkDefault true;
        "gitflow \"hotfix.finish\"".sign = mkDefault true;

        "filter \"lfs\"" = {
          required = mkDefault true;
          clean = mkDefault "git-lfs clean -- %f";
          smudge = mkDefault "git-lfs smudge -- %f";
        };
      };
    };
  };
}
