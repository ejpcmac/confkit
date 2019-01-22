####### Configuration for Vim ##################################################
##                                                                            ##
## * Enable UTF-8 and the mouse                                               ##
## * Display line numbers and a 80 characters ruler                           ##
## * Display the current mode                                                 ##
## * Enable syntax coloring                                                   ##
## * Auto indent, using 2 spaces                                              ##
## * Use the Wellsokai color theme                                            ##
##                                                                            ##
## For an exhaustive list of options, please see `../vim/vimrc`               ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkDefault mkOption types optionalString;
  inherit (pkgs) stdenv;

  cfg = config.programs.vim;
  vimConfig =
    readFile ../vim/vimrc
    # Embed the color theme in the configuration.
    + readFile ../vim/colors/wellsokai.vim
    + optionalString cfg.useBepoKeybindings (readFile ../vim/bepo.vim);
in

{
  options.programs.vim.useBepoKeybindings = mkOption {
    type = types.bool;
    default = false;
  };

  config = {
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
      defaultEditor = mkDefault true;
    };
  };
}
