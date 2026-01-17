####### Configuration for Jujutsu ##############################################
##                                                                            ##
## * Configure the user information from confkit.identity                     ##
## * Sign by default when confkit.programs.gpg is enabled##
## * Use difft for diffs                                                      ##
## * Show the log without pager when running `jj` without arguments           ##
## * Define and use by default a `log_oneline` template that shows both       ##
##   author and commit date, signatures, and puts the change ID close to the  ##
##   commit description to enhance the readability                            ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkOption mkPackageOption;
  inherit (lib.types) bool;
  cfg = config.confkit.programs.jujutsu;
  identity = config.confkit.identity;
in

{
  options.confkit.programs.jujutsu = {
    enable = mkEnableOption "the confkit home configuration for Jujutsu";

    package = mkPackageOption pkgs "jujutsu" {
      default = null;
      example = "unstable.jujutsu";
      extraDescription = ''
        This option must point to the latest version of Jujutsu, as confkit only
        supports the most recent one.
      '';
    };

    gpgSign = mkOption {
      type = bool;
      default = config.confkit.programs.gpg.enable;
      example = true;
      description = ''
        Whether to sign commits with GPG. This defaults to true when the confkit
        GPG module is enabled.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;
      package = cfg.package;

      settings = {
        user = {
          name = mkDefault identity.name;
          email = mkDefault identity.email;
        };

        signing = mkIf cfg.gpgSign {
          behavior = mkDefault "drop";
          backend = mkDefault "gpg";
          key = mkDefault identity.gpgKey;
        };

        git = {
          sign-on-push = mkDefault cfg.gpgSign;
          write-change-id-header = mkDefault true;
        };

        ui = {
          default-command = mkDefault [
            "log"
            "--no-pager"
            "--config"
            "ui.show-cryptographic-signatures=true"
          ];

          diff-formatter = mkDefault "difft";
        };

        templates = {
          log = mkDefault "log_oneline";
        };

        template-aliases = {
          log_oneline = mkDefault ''
            if(root,
              format_root_commit(self),
              label(
                separate(" ",
                  if(current_working_copy, "working_copy"),
                  if(immutable, "immutable", "mutable"),
                  if(conflict, "conflicted"),
                ),
                concat(
                  separate(" ",
                    format_timestamp(author.timestamp()),
                    author.name(),
                    format_timestamp(committer.timestamp()),
                    bookmarks,
                    tags,
                    working_copies,
                    format_short_change_id_with_change_offset(self),
                    format_short_commit_id(commit_id),
                    if(conflict, label("conflict", "conflict")),
                    if(config("ui.show-cryptographic-signatures").as_boolean(),
                      format_short_cryptographic_signature(signature)),
                    if(empty, label("empty", "(empty)")),
                    if(description,
                      description.first_line(),
                      label(if(empty, "empty"), description_placeholder),
                    ),
                  ) ++ "\n",
                ),
              )
            )
          '';

          "format_detailed_signature(signature)" = ''
            coalesce(signature.name(), name_placeholder)
            ++ " <" ++ coalesce(signature.email(), email_placeholder) ++ ">"
            ++ " (" ++ format_timestamp_tz(signature.timestamp()) ++ ")"
          '';

          "format_timestamp_tz(timestamp)" = ''
            timestamp.format("%Y-%m-%d %H:%M:%S %z")
          '';
        };
      };
    };
  };
}
