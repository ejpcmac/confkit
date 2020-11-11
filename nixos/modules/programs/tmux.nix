####### Configuration for tmux #################################################
##                                                                            ##
## * Use C-a instead of C-b as prefix                                         ##
## * Use more natural keybinding for window splitting (- and |)               ##
## * Use Vim-like pane navigation keybindings                                 ##
## * Optionally use keybindings optimised for BÉPO keyboards                  ##
## * Start indexes at 1                                                       ##
## * Use tmuxinator                                                           ##
##                                                                            ##
## For an exhaustive list of options, please see `../misc/tmux[_bepo].conf`   ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkOption mkEnableOption mkIf mkDefault types;
  inherit (lib.trivial) release;
  inherit (pkgs) stdenv;

  cfg = config.confkit.programs.tmux;

  tmuxConfig = if cfg.bepo
               then readFile ../../../misc/tmux_bepo.conf
               else readFile ../../../misc/tmux.conf;
in

{
  options.confkit.programs.tmux = {
    enable = mkEnableOption "the confkit configuration for Tmux";

    bepo = mkOption {
      type = types.bool;
      default = config.confkit.keyboard.layout == "bépo";
      example = true;
      description = "Use keybindings optimised for BÉPO keyboards.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tmuxinator ];

    programs.tmux = {
      enable = true;
    } // (if stdenv.isDarwin then {
      tmuxConfig = mkDefault (tmuxConfig + ''
          bind-key -T copy-mode Enter send-keys -X copy-pipe-and-cancel "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace pbcopy"
        '');
    } else {
      extraConfig = mkDefault (tmuxConfig + ''
          bind-key -T copy-mode Enter send-keys -X copy-selection-and-cancel
        '');
    });
  };
}
