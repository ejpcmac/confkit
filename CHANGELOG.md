# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic
Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

* [Zsh/Elixir] Add `mck` for `mix check`.
* [ranger/bepo] Add `\.` for `fusermount -u %s`.

### Changed

* [Nix/Environment] Do not create `/run/user/0` before to rebuild in `nors`.
* [Zsh/Nix] Do create `/run/user/0` before to rebuild in `snors`. This behaviour
    was here for a personal `TMPDIR` configuration, which I do not need anymore.
    Removing this also follows my will to avoid personal configuration in
    `confkit`.

## [0.0.7] - 2020-05-06

### Added

* [Zsh/Aliases] Add `sra` for `sudo ranger`.
* [ranger/bepo] Add `fa` and `fx` to archive and extract with tar.
* [ranger/bepo] Add `fc`, `fdd` and `fdk` to compress with `xz -9` and
    decompress in-place or keeping the compressed file.
* [ranger/bepo] Add `fz` and `fdz` to archive and extract with zip.

### Changed

* [Nix/tmux] Add support for NixOS 20.03 by using `tmux.extraConfig`. NixOS
    19.09 is still supported.
* [Zsh/ZFS] Set `reservation=1G` when creating a pool with `zpcc`.
* [Zsh/ZFS] Set `ashift=12` when creating a pool with `zpcc`.
* [Zsh/ZFS] Add a `recordsize` column to `zl2`.

### Removed

* [Nix/Utilities] Comment out `vulnix` since one of its dependencies
    (`python-ZODB`) is broken on NixOS 20.03.

### Security

* [Nix/root] Security : Do not use external dependencies.

## [0.0.6] - 2020-01-27

### Added

* [Nix/Utilities] Add `vulnix`, a utility to look for vulnerable packages in the
    Nix store.
* [Nix/Utilities] Add `colordiff`, `dnsutils`, `file`, `ffmpeg`, `inxi`, `jq`,
    `lshw`, `parted`, `pciutils`, `qpdf`, `smartmontools`, `telnet`,
    `traceroute` and `usbutils`.
* [Zsh/Aliases] Add the `random-string <num_chars>` function.
* [Zsh/Aliases] Add `wn` for `watch -n 1 nmcli`.
* [Zsh/Docker] Add start / stop aliases.
* [Zsh/Docker] Add `--sig-proxy=false` to the `docker attach` alias.
* [Zsh/Docker] Add volume management aliases.
* [Zsh/Git] Add setup and aliases for `hub`, the GitHub CLI.
* [Zsh/Nix] Add aliases to diff the package list before (configuration) updates.
* [Zsh/ZFS] Add `zl2` as a `zfs list` alias with different options than `zl`.
* [Zsh/ZFS] Add aliases for `sudo` operations.
* [Zsh/ZFS] Add aliases for `watch` operations.
* [Zsh/ZFS] Add more `zpool` aliases.
* [ranger/bepo] Add `È` to edit as root.
* [ranger/bepo] Add `gt` to go to `/tmp`.

### Changed

* [Nix/Environment] Create the `$TMPDIR` before to rebuild in `nors`.
* [Zsh/Nix] Create the `$TMPDIR` before to rebuild in `snors`.
* [Zsh/direnv] Make `dl` look at `~/Informatique` instead of `~/Programmes` and
    add a comment to make clear it is provided as an example.
* [Zsh/Rust] Change `cia`: remove `cargo-vendor`, `cargo-geiger` and
    `cargo-audit`, add `cargo-crev`.
* [ranger/bepo] Open the current directory with Emacs on `e`.
* [Tmux] Use the color 231 instead of 15 for white to avoid issue with terminal
    theme switches.

### Fixed

* [Zsh/Aliases] `gmod` and `gmodg` now work as expected, setting 644 for files.

## [0.0.5] - 2019-05-05

### Added

* [Nix/Utilities] Add some useful system packages.
* [Zsh/dev] Add aliases to start-stop a local MongoDB instance.
* [Zsh/Django] Add aliases for Django.
* [Zsh/ImageMagick] Add functions for working with ImageMagick.
* [Zsh/Rust] Add `cs` and `csr` for `cargo size [--release] --bin`.
* [Zsh/ZFS] Add `zlk` and `zulk` for `zfs [un]load-key`.
* [Zsh/ZFS] Add a few aliases for `zpool`.
* [pms] Add a pms configuration with BÉPO keybindings.
* [ranger/bepo] Add an alias (`\u`) to mount using `udisksctl`.
* [tridactyl] Add basic BÉPO keybindings.
* [Zathura] Add a configuration for BÉPO.

### Changed

* [Nix/Tmux] Install tmuxinator automatically.
* [Zsh/Aliases] Change `oc` and `ocd` to use `~/config` instead of
    `~/config_files`.
* [Zsh/dev] Update `pgst` to put the socket in $PGDATA.
* [Zsh/Rust] Add cargo-generate and cargo-binutils installation to `cia`.
* [ranger] Rename `ranger/rc.conf` to `ranger/bepo_rc.conf`.
* [ranger/bepo] Use `\\` to unmount as user, `\!` as root.

### Fixed

* [Tmux] Make the configuration compatible with Tmux 2.9.

## [0.0.4] - 2019-02-02

### Added

* [Nix/Vim] Add the `programs.vim.useBepoKeybindings` option.
* [Zsh/dev] Introduce a module for developer-focused aliases and functions:
    * PostgreSQL aliases,
    * Shortcut to disable formatting locally in VSCode,
    * Certificate generation.
* [Zsh/Aliases] Add `ra` for `ranger`.
* [Zsh/Aliases] Add `ec[c|t]` for `emacsclient [-c|-nw]`.
* [Zsh/Elixir] Add `mcvf` pour `mix compile --verbose --force`.
* [Scripts/open-editor] Add a script to open an editor. Trys Emacs, Vim, nano,
    ee and vi.
* [Vim] Add BÉPO mappings.
* [Vim] Use `<C-l>` to center the cursor.
* [Tmux] Add session management commands.
* [ranger] Add a ranger configuration.

### Changed

* [Zsh/zshrc] Automatically choose the editor in the out-of-Nix system `zshrc`.
    The default editor is Emacs, using the deamon. If it is not available or the
    daemon is not started, falls back to vim, then nano, then ee, then vi. For
    this to work, `scripts/open-editor` must be installed in `/usr/bin`.
* [Zsh/Aliases] Use Emacs to edit the configuration.
* [Zsh/Aliases] Move PostgreSQL aliases to the `dev` module.
* [Zsh/Elixir] Update the Nerves aliases to push firmwares.
* [Tmux] Update the pane navigation to be a bit more Vim-like.
    * Use `C-<c,t,s,r>` to move btween panes and `C-<v/q,n>` to move between
      windows.

### Removed

* [Nix/xserver] Remove common configuration.

### Fixed

* [Zsh/Git] Make `gclean` avoid cleaning `.direnv/` if it is not at the root.

## [0.0.3] - 2019-01-02

### Added

* [Zsh/Nix] Add s-prefixed aliases to sudo `nic*` and `nors`.

### Changed

* [Example] Enhance the configuration.

## [0.0.2] - 2019-01-01

### Changed

* Enhance the NixOS configuration example.

### Fixed

* Fix NixOS compatibility issues.

## [0.0.1] - 2018-12-30

### Added

* Extraction from my personal configuration framework.

[Unreleased]: https://github.com/ejpcmac/confkit/compare/master...develop
[0.0.7]: https://github.com/ejpcmac/confkit/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/ejpcmac/confkit/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/ejpcmac/confkit/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/ejpcmac/confkit/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/ejpcmac/confkit/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/ejpcmac/confkit/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/ejpcmac/confkit/releases/tag/v0.0.1
