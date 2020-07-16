####### Configuration for Zsh ##################################################
##                                                                            ##
## * Configure the prompt to be blue in Nix shells                            ##
## * Enable Oh My Zsh with nix-shell and sudo plugins                         ##
## * Use the Bazik Oh My Zsh theme from confkit                               ##
## * Provide the confkit.zsh.plugins configuration option to select which     ##
##   plugins from confkit/zsh are to be linked to $HOME/.zsh                  ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkOption mkEnableOption mkIf mkMerge types;
  cfg = config.confkit.zsh;
in

{
  options.confkit.zsh = {
    enable = mkEnableOption "the confkit home configuration for Zsh";

    plugins = mkOption {
      type = types.listOf types.str;
      default = [ "aliases" ];
      example = [ "aliases" "git" "nix" ];
      description = ''
        The list of plugins to enable.

        A plugin is a file in confkit/zsh. For instance, to include aliases
        defined in confkit/zsh/nix.zsh, set confkit.zsh.plugins = [ "nix" ];
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.zsh = {
        enable = true;
        initExtra = readFile ../../zsh/config/home_init.zsh;

        oh-my-zsh = {
          enable = true;
          custom = "$HOME/.zsh-custom";
          theme = "bazik";
          plugins = [ "nix-shell" "sudo" ];
        };
      };

      home.file.".zsh-custom/themes/bazik.zsh-theme".source =
        ../../zsh/themes/bazik.zsh-theme;
    }

    {
      home.file = map (plugin: {
        target = ".zsh/${plugin}.zsh";
        source = ../../zsh + "/${plugin}.zsh";
      }) cfg.plugins;
    }
  ]);
}