####### Configuration for tmux #################################################
##                                                                            ##
## * Use C-a instead of C-b as prefix                                         ##
## * Use more natural keybinding for window splitting (- and |)               ##
## * Start indexes at 1                                                       ##
## * Use tmuxinator                                                           ##
##                                                                            ##
## For an exhaustive list of options, please see `../misc/tmux.conf`          ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
  inherit (pkgs) stdenv;

  tmuxConfig = builtins.readFile ../misc/tmux.conf;
in

{
  environment.systemPackages = [ pkgs.tmuxinator ];

  programs.tmux = if stdenv.isDarwin then {
    enable = true;
    tmuxConfig = mkDefault (tmuxConfig + ''
        bind-key -T copy-mode Enter send-keys -X copy-pipe-and-cancel "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace pbcopy"
      '');
  } else {
    enable = true;
    extraTmuxConf = mkDefault (tmuxConfig + ''
        bind-key -T copy-mode Enter send-keys -X copy-selection-and-cancel
      '');
  };
}
