# Changelog

## develop

### Breaking changes

* [ranger] Use `\\` to unmount as user, `\!` as root

### New features

* [pms] Add a pms configuration with BÉPO keybindings
* [ranger] Add an alias (`\u`) to mount using `udisksctl`
* [tridactyl] Add basic BÉPO keybindings
* [Zsh/ImageMagick] Add functions for working with ImageMagick

## v0.0.4

### Breaking changes

* [Zsh/zshrc] Automatically choose the editor in the out-of-Nix system `zshrc`.
    The default editor is Emacs, using the deamon. If it is not available or the
    daemon is not started, falls back to vim, then nano, then ee, then vi. For
    this to work, `scripts/open-editor` must be installed in `/usr/bin`.
* [Zsh/Aliases] Use Emacs to edit the configuration
* [Zsh/Aliases] Move PostgreSQL aliases to the `dev` module
* [Tmux] Update the pane navigation to be a bit more Vim-like
    * Use `C-<c,t,s,r>` to move btween panes and `C-<v/q,n>` to move between
      windows
* [Nix/xserver] Remove common configuration

### New features

* [scripts/open-editor] Add a script to open an editor. Trys Emacs, Vim, nano,
    ee and vi.
* [Zsh/Aliases] Add `ra` for `ranger` and `ec[c|t]` for `emacsclient [-c|-nw]`
* [Zsh/dev] Introduce a module for developer-focused aliases and functions
    * PostgreSQL aliases
    * Shortcut to disable formatting locally in VSCode
    * Certificate generation
* [Zsh/Elixir] Add `mcvf` pour `mix compile --verbose --force`
* [Vim] Add BÉPO mappings
* [ranger] Add a ranger configuration
* [Nix/Vim] Add the `programs.vim.useBepoKeybindings` option

### Enhancements

* [Zsh/Git] Make `gclean` avoid cleaning `.direnv/` if it is not at the root
* [Zsh/Elixir] Update the Nerves aliases to push firmwares
* [Tmux] Add session management commands
* [Vim] Use `<C-l>` to center the cursor

## v0.0.3

* [Zsh/Nix] Add s-prefixed aliases to sudo `nic*` and `nors`
* [Example] Enhance the configuration

## v0.0.2

* Fix NixOS compatibility issues
* Enhance the NixOS configuration example

## v0.0.1

* Extraction from my personal configuration framework
