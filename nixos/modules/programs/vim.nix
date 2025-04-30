####### Configuration for Vim ##################################################
##                                                                            ##
## * Enable UTF-8 and the mouse                                               ##
## * Display line numbers and a 80 characters ruler                           ##
## * Display the current mode                                                 ##
## * Enable syntax coloring                                                   ##
## * Auto indent, using 2 spaces                                              ##
## * Use the Wellsokai color theme                                            ##
## * Optionally use keybindings optimised for BÉPO keyboards                  ##
##                                                                            ##
## For an exhaustive list of options, please see `../vim/vimrc`               ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkDefault mkEnableOption mkIf mkOption optionalString;
  inherit (lib.types) bool;
  inherit (pkgs) stdenv;

  cfg = config.confkit.programs.vim;

  vimConfig =
    readFile ../../../vim/vimrc
    # Embed the color theme in the configuration.
    + readFile ../../../vim/colors/wellsokai.vim
    + optionalString cfg.bepo (readFile ../../../vim/bepo.vim);
in

{
  options.confkit.programs.vim = {
    enable = mkEnableOption "the confkit configuration for Vim";

    defaultEditor = mkOption {
      type = bool;
      default = true;
      example = false;
      description = "Whether to set Vim as the default editor.";
    };

    bepo = mkOption {
      type = bool;
      default = config.confkit.keyboard.layout == "bépo";
      example = true;
      description = "Use keybindings optimised for BÉPO keyboards.";
    };
  };

  config = mkIf cfg.enable {
    programs.vim = {
      enable = true;
    } // (if stdenv.isDarwin then {
      vimConfig = mkDefault (vimConfig + "set clipboard=unnamed");
    } else {
      package = pkgs.vim_configurable.customize {
        name = "vim";
        vimrcConfig.customRC = vimConfig;
      };
      defaultEditor = cfg.defaultEditor;
    });
  };
}
