##
## Common home configuration
##

{ config, pkgs, ... }:

let
  inherit (builtins) readFile;
  confkit = import ../../confkit;
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  home.stateVersion = "18.09";  # Did you read the comment?

  imports = with confkit.modules; [ git ];

  home.packages = with pkgs; [
    bashInteractive
    # direnv
  ];

  home.file = {
    # Zsh aliases and environments
    ".zsh/aliases.zsh".source = confkit.file "zsh/aliases.zsh";
    # ".zsh/asdf.zsh".source = confkit.file "zsh/asdf.zsh";
    # ".zsh/ceedling.zsh".source = confkit.file "zsh/ceedling.zsh";
    # ".zsh/direnv.zsh".source = confkit.file "zsh/direnv.zsh";
    # ".zsh/docker.zsh".source = confkit.file "zsh/docker.zsh";
    # ".zsh/elixir.zsh".source = confkit.file "zsh/elixir.zsh";
    ".zsh/git.zsh".source = confkit.file "zsh/git.zsh";
    # ".zsh/haskell.zsh".source = confkit.file "zsh/haskell.zsh";
    ".zsh/nix.zsh".source = confkit.file "zsh/nix.zsh";
    # ".zsh/ocaml.zsh".source = confkit.file "zsh/ocaml.zsh";
    # ".zsh/rust.zsh".source = confkit.file "zsh/rust.zsh";
    # ".zsh/zfs.zsh".source = confkit.file "zsh/zfs.zsh";

    # Zsh themes
    ".zsh-custom/themes/bazik.zsh-theme".source = confkit.file "zsh/themes/bazik.zsh-theme";

    # Non-natively handled configuration files
    # ".screenrc".source = confkit.file "misc/screenrc";
    ".gnupg/gpg.conf".text = ''
        default-key <key>
      '' + readFile (confkit.file "misc/gpg.conf");
  };

  programs.home-manager = {
    enable = true;
  };

  programs.git = {
    userName = "User Name";
    userEmail = "user.name@example.com";
    # signing.signByDefault = false;
    signing.key = "<key>";
  };

  programs.zsh = {
    enable = true;
    initExtra = readFile (confkit.file "zsh/config/home_init.zsh");

    oh-my-zsh = {
      enable = true;

      custom = "$HOME/.zsh-custom";
      theme = "bazik";

      plugins = [
        "git"
        "git-flow"
        "nix-shell"
        "sudo"
        "zsh-syntax-highlighting"
      ];
    };

    # shellAliases = {
    #   tmux = "direnv exec / tmux";
    # };
  };
}
