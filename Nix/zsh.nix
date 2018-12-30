####### Configuration for Zsh ##################################################
##                                                                            ##
## * No beeps                                                                 ##
## * Sensible and intuitive completion scheme                                 ##
## * Prompt like `[user@host.domain]:/path %` in green, and red for root      ##
## * 10 000 lines history in `~/.zsh_history` without immediate duplicates    ##
## * Correct UTF-8 handling on macOS                                          ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkDefault optionalString;
  inherit (pkgs) stdenv;

  shellInit = readFile ../zsh/config/config.zsh
    + optionalString stdenv.isDarwin (readFile ../zsh/config/macos.zsh);
in

{
  environment.shells = [ pkgs.zsh ];

  programs.zsh =
    let zsh-common = {
      enable = true;
      enableCompletion = mkDefault true;

      interactiveShellInit = mkDefault shellInit;
      promptInit = mkDefault (readFile ../zsh/config/prompt.zsh);
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
}
