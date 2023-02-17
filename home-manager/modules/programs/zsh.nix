####### Configuration for Zsh ##################################################
##                                                                            ##
## * Configure the prompt to be blue in Nix shells                            ##
## * Optionally enable Oh My Zsh with nix-shell and sudo plugins              ##
## * Use the Bazik Oh My Zsh theme from confkit                               ##
## * Provide the confkit.prgorams.zsh.plugins configuration option to select  ##
##   which plugins from confkit/zsh are to be installed $HOME/.zsh            ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (builtins) readFile listToAttrs;
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.confkit.programs.zsh;
in

{
  options.confkit.programs.zsh = {
    enable = mkEnableOption "the confkit home configuration for Zsh";

    plugins = mkOption {
      type = types.listOf types.str;
      default = [ "aliases" "nix" ];
      example = [ "aliases" "git" "nix" ];
      description = ''
        The list of plugins to enable.

        A plugin is a file in confkit/zsh. For instance, to include aliases
        defined in confkit/zsh/nix.zsh, set confkit.zsh.plugins = [ "nix" ];
      '';
    };

    ohMyZsh = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Wether to enable Oh My Zsh.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.zsh = {
        enable = true;
        initExtra = readFile ../../../zsh/config/home_init.zsh;

        oh-my-zsh = mkIf cfg.ohMyZsh {
          enable = true;
          custom = mkDefault "$HOME/.zsh-custom";
          theme = mkDefault "bazik";
          plugins = [ "nix-shell" "sudo" ];
        };
      };

      home.file = mkIf cfg.ohMyZsh {
        ".zsh-custom/themes/bazik.zsh-theme".source =
          ../../../zsh/themes/bazik.zsh-theme;
      };
    }

    {
      home.file = listToAttrs (map
        (plugin: {
          name = ".zsh/${plugin}.zsh";
          value.source = ../../../zsh + "/${plugin}.zsh";
        })
        cfg.plugins);
    }
  ]);
}
