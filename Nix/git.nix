####### Configuration for Git ##################################################
##                                                                            ##
## * Sign by default, using `gpg2` (including gitflow)                        ##
## * Always create a merge commit by default (including gitflow)              ##
## * Rebase on pull, preserving previous merge commits                        ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in

{
  programs.git = {
    enable = true;

    signing = {
      gpgPath = mkDefault "gpg2";
      signByDefault = mkDefault true;
    };

    extraConfig = mkDefault {
      merge.ff = false;
      pull.rebase = "preserve";
      mergetool.keepBackup = false;

      "gitflow \"feature.finish\"".no-ff = true;
      "gitflow \"release.finish\"".sign = true;
      "gitflow \"hotfix.finish\"".sign = true;

      "filter \"lfs\"" = {
        required = true;
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
      };
    };
  };
}
