##
## Home configuration for user@darwin-host
##

{ config, pkgs, ... }:

let
  confkit = import ../../confkit;
in

{
  imports = [ ../common/home.nix ];

  home.packages = with pkgs; [ duti ];

  home.file = {
    # darwin-host-only Zsh aliases
    ".zsh/gpg-agent.zsh".source = confkit.file "zsh/gpg-agent.zsh";
  };

  programs.zsh = {
    oh-my-zsh.plugins = [ "osx" ];

    shellAliases = {
      # Use macOS `ls` instead of Oh My Zsh one
      ls = "/bin/ls -Gh";

      # Frequent commands
      op = "open";

      # Hibernation modes
      hm-fast = "sudo pmset hibernatemode 0";
      hm-sleep = "sudo pmset hibernatemode 3";
      hm-hibernate = "sudo pmset hibernatemode 25";
    };
  };
}
