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
  inherit (builtins) readFile;
  inherit (lib) mkDefault mkOption types;
  inherit (lib.trivial) release;
  inherit (pkgs) stdenv;

  cfg = config.programs.tmux;
  tmuxConfig = if cfg.useBepoKeybindings
               then readFile ../misc/tmux_bepo.conf
               else readFile ../misc/tmux.conf;
in

{
  options.programs.tmux.useBepoKeybindings = mkOption {
    type = types.bool;
    default = false;
  };

  config = {
    environment.systemPackages = [ pkgs.tmuxinator ];

    programs.tmux = {
      enable = true;
    } // (if stdenv.isDarwin then {
      tmuxConfig = mkDefault (tmuxConfig + ''
          bind-key -T copy-mode Enter send-keys -X copy-pipe-and-cancel "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace pbcopy"
        '');
    } else if release == "20.03" then {
      extraConfig = mkDefault (tmuxConfig + ''
          bind-key -T copy-mode Enter send-keys -X copy-selection-and-cancel
        '');
    } else {
      extraTmuxConf = mkDefault (tmuxConfig + ''
          bind-key -T copy-mode Enter send-keys -X copy-selection-and-cancel
        '');
    });
  };
}
