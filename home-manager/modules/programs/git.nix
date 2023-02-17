####### Configuration for Git ##################################################
##                                                                            ##
## * Configure the user information from confkit.identity                     ##
## * Sign by default (including git-flow) when confkit.programs.gpg is enabled##
## * Always create a merge commit by default (including gitflow)              ##
## * Rebase on pull, preserving previous merge commits                        ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkDefault types;
  cfg = config.confkit.programs.git;
  identity = config.confkit.identity;
in

{
  options.confkit.programs.git = {
    enable = mkEnableOption "the confkit home configuration for Git";

    gpgSign = mkOption {
      type = types.bool;
      default = config.confkit.programs.gpg.enable;
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

      aliases = {
        fixup = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";
      };

      extraConfig = {
        init.defaultBranch = mkDefault "main";
        merge.ff = mkDefault false;
        pull.rebase = mkDefault "merges";
        rebase.autosquash = mkDefault true;
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
