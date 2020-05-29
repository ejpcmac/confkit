# Changelog

## develop

### Enhancements

* [Zsh/Elixir] Add `mck` for `mix check`

## v0.0.7

### Breaking changes

* [Nix/Utilities] Comment out `vulnix` since one of its dependencies
    (`python-ZODB`) is broken on NixOS 20.03

### Enhancements

* [Nix/root] Security : Do not use external dependencies
* [Nix/tmux] Use `tmux.extraConfig` from NixOS 20.03
* [ranger/bepo] Add `fa` and `fx` to archive and extract with tar
* [ranger/bepo] Add `fc`, `fdd` and `fdk` to compress with `xz -9` and
    decompress in-place or keeping the compressed file
* [ranger/bepo] Add `fz` and `fdz` to archive and extract with zip
* [Zsh/Aliases] Add `sra` for `sudo ranger`
* [Zsh/ZFS] Add a reservation when creating a pool with `zpcc`
* [Zsh/ZFS] Set `ashift=12` when creating a pool with `zpcc`
* [Zsh/ZFS] Add a `recordsize` column to `zl2`

## v0.0.6

### Breaking changes

* [ranger/bepo] Open the current directory with Emacs on `e`
* [Zsh/direnv] Make `dl` look at `~/Informatique` instead of `~/Programmes` and
    add a comment to make clear it is provided as an example

### New features

* [Nix/Utilities] Add `vulnix`, a utility to look for vulnerable packages in the
    Nix store
* [Zsh/Aliases] Add the `random-string <num_chars>` function
* [Zsh/Git] Add setup and aliases for `hub`, the GitHub CLI
* [Zsh/Nix] Add aliases to diff the package list before (configuration) updates

### Enhancements

* [Nix/Environment] Create the `$TMPDIR` before to rebuild in `nors`
* [Nix/Utilities] Add `colordiff`, `dnsutils`, `file`, `ffmpeg`, `inxi`, `jq`,
    `lshw`, `parted`, `pciutils`, `qpdf`, `smartmontools`, `telnet`,
    `traceroute` and `usbutils`
* [ranger/bepo] Add `È` to edit as root
* [ranger/bepo] Add `gt` to go to `/tmp`
* [Tmux] Use the color 231 instead of 15 for white to avoid issue with terminal
    theme switches
* [Zsh/Aliases] Add `wn` for `watch -n 1 nmcli`
* [Zsh/Aliases] `gmod` and `gmodg` now work as expected, setting 644 for files
* [Zsh/Docker] Add start / stop aliases
* [Zsh/Docker] Add `--sig-proxy=false` to the `docker attach` alias
* [Zsh/Docker] Add volume management aliases
* [Zsh/Nix] Create the `$TMPDIR` before to rebuild in `snors`
* [Zsh/Rust] Change `cia`: remove `cargo-vendor`, `cargo-geiger` and
    `cargo-audit`, add `cargo-crev`
* [Zsh/ZFS] Add aliases for `sudo` operations
* [Zsh/ZFS] Add `zl2` as a `zfs list` alias with different options than `zl`
* [Zsh/ZFS] Add watch operations
* [Zsh/ZFS] Add more `zpool` aliases

## v0.0.5

### Breaking changes

* [ranger] Rename `ranger/rc.conf` to `ranger/bepo_rc.conf`
* [ranger] Use `\\` to unmount as user, `\!` as root
* [Zsh/Aliases] Change `oc` and `ocd` to use `~/config`

### New features

* [Nix/Utilities] Add some useful system packages
* [pms] Add a pms configuration with BÉPO keybindings
* [ranger] Add an alias (`\u`) to mount using `udisksctl`
* [tridactyl] Add basic BÉPO keybindings
* [Zathura] Add a configuration for BÉPO
* [Zsh/Django] Add aliases for Django
* [Zsh/ImageMagick] Add functions for working with ImageMagick

### Enhancements

* [Nix/Tmux] Install tmuxinator automatically
* [Zsh/dev] Update `pgst` to put the socket in $PGDATA
* [Zsh/dev] Add aliases to start-stop a local MongoDB instance
* [Zsh/Rust] Add cargo-generate and cargo-binutils installation to `cia`
* [Zsh/Rust] Add `cs` and `csr` for `cargo size [--release] --bin`
* [Zsh/ZFS] Add `zlk` and `zulk` for `zfs [un]load-key`
* [Zsh/ZFS] Add a few aliases for `zpool`

### Bug fixes

* [Tmux] Make the configuration compatible with Tmux 2.9

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
