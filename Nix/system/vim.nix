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
  inherit (lib) mkEnableOption mkOption mkIf mkDefault types optionalString;
  inherit (pkgs) stdenv;

  cfg = config.confkit.vim;

  vimConfig =
    readFile ../../vim/vimrc
    # Embed the color theme in the configuration.
    + readFile ../../vim/colors/wellsokai.vim
    + optionalString cfg.bepo (readFile ../../vim/bepo.vim);
in

{
  options.confkit.vim = {
    enable = mkEnableOption "the confkit configuration for Vim";

    defaultEditor = mkOption {
      type = types.bool;
      default = true;
      description = "Wether to set Vim as the default editor.";
    };

    bepo = mkOption {
      type = types.bool;
      default = false;
      description = "Use keybindings optimised for BÉPO keyboards.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = if stdenv.isLinux then [
      (pkgs.vim_configurable.customize {
        name = "vim";
        vimrcConfig.customRC = vimConfig;
      })
    ] else [];

    programs.vim = if stdenv.isDarwin then {
      enable = true;
      vimConfig = mkDefault (vimConfig + "set clipboard=unnamed");
    } else {
      defaultEditor = cfg.defaultEditor;
    };
  };
}
