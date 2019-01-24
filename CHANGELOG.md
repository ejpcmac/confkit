# Changelog

## develop

### Breaking changes

* [Zsh/Aliases] Move PostgreSQL aliases to the `dev` module
* [tmux] Update the pane navigation to be a bit more Vim-like
    * Use `C-<ctsr>` to move btween panes and `C-<qn>` to move between windows
* [Nix/xserver] Remove common configuration

### New features

* [Zsh/Aliases] Add `ra` for `ranger`
* [Zsh/dev] Introduce a module for developer-focused aliases and functions
    * PostgreSQL aliases
    * Shortcut to disable formatting locally in VSCode
    * Certificate generation
* [Zsh/Elixir] Add `mcvf` pour `mix compile --verbose --force`
* [Vim] Add BÉPO mappings
* [ranger] Add a ranger configuration
* [Nix/Vim] Add the `programs.vim.useBepoKeybindings` option

### Enhancements

* [tmux] Add session management commands

## v0.0.3

* [Zsh/Nix] Add s-prefixed aliases to sudo `nic*` and `nors`
* [Example] Enhance the configuration

## v0.0.2

* Fix NixOS compatibility issues
* Enhance the NixOS configuration example

## v0.0.1

* Extraction from my personal configuration framework
