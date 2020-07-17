####### Configuration for Zsh ##################################################
##                                                                            ##
## * No beeps                                                                 ##
## * Syntax highlighting                                                      ##
## * Sensible and intuitive completion scheme                                 ##
## * Prompt like `[user@host.domain]:/path %` in green, and red for root      ##
## * 10 000 lines history in `~/.zsh_history` without immediate duplicates    ##
## * Correct UTF-8 handling on macOS                                          ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkEnableOption mkIf mkDefault optionalString;
  inherit (pkgs) stdenv;

  cfg = config.confkit.zsh;
in

{
  options.confkit.zsh = {
    enable = mkEnableOption "the confkit configuration for Zsh";
  };

  config = mkIf cfg.enable {
    environment.shells = [ pkgs.zsh ];

    programs.zsh =
      let zsh-common = {
        enable = true;
        enableCompletion = mkDefault true;
        syntaxHighlighting.enable = mkDefault true;
        promptInit = mkDefault (readFile ../../zsh/config/prompt.zsh);

        interactiveShellInit = ''
          # Disable beeps.
          unsetopt beep
          unsetopt hist_beep
          unsetopt list_beep

          # Complete to the common part and show the list of possible completion
          # the same tab hit.
          unsetopt list_ambiguous
        '' + optionalString stdenv.isDarwin ''
          # Correctly display UTF-8 with combining characters.
          if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
              setopt combiningchars
          fi
        '';

        setOptions = [
          "EXTENDEDGLOB"
          "SHARE_HISTORY"
          "HIST_IGNORE_DUPS"
          "HIST_EXPIRE_DUPS_FIRST"
          "HIST_FIND_NO_DUPS"
          "HIST_FCNTL_LOCK"
        ];
      }; in
      if stdenv.isDarwin then zsh-common // {
        enableBashCompletion = mkDefault true;

        variables = {
          # nix-darwin sets default values that override the ones set in the
          # shellInit script. We must set them again here.
          HISTORY = mkDefault "10000";
          SAVEHIST = mkDefault "10000";
          HISTFILE = mkDefault "$HOME/.zsh_history";
        };
      }
      else zsh-common;
  };
}
