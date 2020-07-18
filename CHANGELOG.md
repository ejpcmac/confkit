# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic
Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

* [Zsh/aliases] `e` Now opens the current directory with `codium` instead of
  `code`.
* [ranger/*] `E` now opens the current directory with `codium` instead of
  `code`.

## [0.0.9] - 2020-07-17

### Highlights

The way `confkit` modules and files are imported in the configuration has been
completely reworked to behave like a NixOS or `home-manager` module. This will
enable more fine-grained control about what `confkit` adds to your configuration
thanks to new options.

Starting this version, `confkit` provides a NixOS module in `confkit/nixos` and
a `home-manager` module in `confkit/home-manager`, adding `confkit.*` options to
your configurations. Each configuration module need to be enable by setting
`confkit.<module>.enable = true;` in your configuration. Furthermore, the old
`confkit.*` modules and the `confkit.file` function have been removed in favor
of the new configuration modules.

For instance, if you had a NixOS configuration like this:

```nix
let
  confkit = import ../../confkit;
in

{
  # With this method you had no control about what a module includes: it is
  # there or not.
  imports = with confkit.modules; [
    environment
    nix
    tmux
    utilities
    vim
    zsh
  ];

  # Some modules already provided a configuration option to change the
  # keybindings, but adding these to programs.<module>, which is not clear.
  programs.tmux.useBepoKeybindings = true;
  programs.vim.useBepoKeybindings = true;

  # Some configuration, yet available in confkit, was not available through a
  # module. It instead relied on manual import by the end user, like for the
  # ranger configuration.
  environment = {
    etc = {
      "ranger/rc.conf".source = confkit.file "ranger/bepo_rc.conf";
      "ranger/scope.sh".source = "${pkgs.ranger}/share/doc/ranger/config/scope.sh";
    };

    variables = {
      # Only use /etc/ranger/rc.conf and ~/.config/ranger/rc.conf
      RANGER_LOAD_DEFAULT_RC = "FALSE";
    };
  };
}
```

You have to update it to:

```nix
{
  # Now you just need to import the confkit NixOS module.
  imports = [ ../../confkit/nixos ];

  # You can then enable and configure confkit configuration modules.
  confkit = {
    nix.enable = true;
    ranger.enable = true; # New module, yay!
    shell.enable = true;  # environment has been renamed to shell.
    tmux.enable = true;
    utilities.enable = true;
    vim.enable = true;
    zsh.enable = true;

    # If you are typing with the BÉPO layout, you can enable optimised
    # keybindings for several tools in one line. It currently applies to ranger,
    # Tmux and Vim. You can also configure this for individual tools by doing
    # vim.bepo = true; for instance.
    keyboard.bepo = true;
  };
}
```

Configuration related to user homes is provided as a `home-manager` module. If
you were writing this:

```nix
let
  confkit = ../../confkit;
in

{
  # Standard module import.
  imports = with confkit.modules; [ git ];

  # Lots of confkit.file linked manually.
  home.file = {
    # These are Zsh plugins.
    ".zsh/aliases.zsh".source = confkit.file "zsh/aliases.zsh";
    ".zsh/git.zsh".source = confkit.file "zsh/git.zsh";
    ".zsh/imagemagick.zsh".source = confkit.file "zsh/imagemagick.zsh";
    ".zsh/nix.zsh".source = confkit.file "zsh/nix.zsh";

    # Zsh themes.
    ".zsh-custom/themes/bazik.zsh-theme".source = confkit.file "zsh/themes/bazik.zsh-theme";

    # Some GPG configuration with manual concatenation.
    ".gnupg/gpg.conf".text = ''
        default-key <some fpr>
      '' + readFile (confkit.file "misc/gpg.conf");
  };

  xdg.configFile = {
    "pms/pms.conf".source = confkit.file "misc/pms_bepo.conf";
    "zathura/zathurarc".source = confkit.file "misc/zathurarc_bepo";
    "tridactyl/tridactylrc".text =
      readFile (confkit.file "misc/tridactylrc_bepo")
      + "\nset editorcmd ${pkgs.emacs}/bin/emacsclient --create-frame";
  };

  programs.git = {
    userName = "John Doe";
    userEmail = "john.doe@example.com";
    # Redundancy for the fingerprint.
    signing.key = "<some fpr>";
  };

  # Some boilerplate.
  programs.zsh = {
    enable = true;
    initExtra = readFile (confkit.file "zsh/config/home_init.zsh");

    oh-my-zsh = {
      enable = true;

      custom = "$HOME/.zsh-custom";
      theme = "bazik";

      plugins = [
        "git"
        "nix-shell"
        "sudo"
      ];
    };
  };
}
```

You have to update it to:

```nix
{
  imports = [ ../../confkit/home-manager ];

  confkit = {
    # The home-manager module provides an identity attribute set to gather
    # information that can be used by other modules.
    identity = {
      name = "John Doe";               # Used by confkit.git.
      email = "john.doe@example.com";  # Used by confkit.git.
      gpgKey = "<some fpr>";           # Used by confkit.git and confkit.gpg.
    };

    # Like in the system configuration, you now have a switch to select
    # BÉPO-optimised keybindings here. It currently applies to pms, Zathura and
    # Tridactyl.
    keyboard.bepo = true;

    git.enable = true;
    gpg.enable = true;
    pms.enable = true;
    zathura.enable = true;

    tridactly = {
      enable = true;
      editor = "${pkgs.emacs}/bin/emacsclient --create-frame";
    };

    zsh = {
      enable = true;
      ohMyZsh = true;

      # Manual confkit.file calls are replaced by a plugin list.
      plugins = [ "aliases" "git" "imagemagick" "nix" ];
    };
  };

  # nix-shell and sudo are imported confkit, just add the other ones.
  programs.zsh.oh-my-zsh.plugins = [ "git" ];
}
```

### Added

* [NixOS/ranger] Add the option `confkit.ranger.enable` to install `ranger` with
    a configuration. You can use bindings optimised for BÉPO keyboards by
    setting `confkit.ranger.bepo = true;`.
* [NixOS/keyboard] Add the option `confkit.keyboard.bepo` to enable
    BÉPO-optimised keybindings by default in all modules supporting it.
* [home-manager/identity] Add the `confkit.identity` attribute set to define
    globally your `name`, `email` and `gpgKey` so they can be used by other
    configuration modules. Now the Git and GPG modules are using it.
* [home-manager/GPG] Add the option `confkit.gpg.enable` to install the GPG
    configuration from `confkit`.
* [home-manager/pms] Add the option `confkit.pms.enable` to install `pms` with a
    configuration. As there is only a configuration for BÉPO keyboards at the
    time, it is also mandatory to set `confkit.pms.bepo = true;`.
* [home-manager/screen] Add the option `confkit.screen.enable` to install a
    basic configuration for `screen`, just setting the `termcapinfo`.
* [home-manager/Tridactyl] Add the option `confkit.tridactyl.enable` to install
    the configuration for Tridactyl. As there is only a configuration for BÉPO
    keyboards at the time, it is also mandatory to set `confkit.tridatctyl.bepo
    = true;`.
* [home-manager/Zathura] Add the option `confkit.zathura.enable` to install
    Zathura with a configuration. You can use bindings optimised for BÉPO
    keyboards by setting `confkit.zathura.bepo = true;`.
* [home-manager/Zsh] Add the option `confkit.zsh.enable` to enable Zsh and Oh My
    Zsh with a configuration. Plugins from `confkit/zsh` can be enabled through
    the `confkit.zsh.plugins` configuration option.
* [home-manager/keyboard] Add the option `confkit.keyboard.bepo` to enable
    BÉPO-optimised keybindings by default in all modules supporting it.
* [Zsh/Xen] Add aliases for Xen.

### Changed

* [Nix] Convert to a NixOS / home-manager module system. All modules now need to
    be enabled by setting `confkit.<module>.enable = true;`. These new
    configuration options are made available by importing `confkit/nixos` or
    `confkit/home-manager`.
* [NixOS/environment] Rename to shell.
* [NixOS/shell] Do not pre-build the configuration when running `nors`. The
    previous behaviour is now usable through the `bnors` alias, available in the
    Nix Zsh plugin, by adding `confkit.zsh.plugins = [ "nix" ];` to your home
    conifguration.
* [NixOS/shell] Bring in `nic{,l,a,r,u}` aliases from `confkit/zsh/nix.zsh`.
* [NixOS/Zsh] Enable syntax highlighting.
* [home-manager/Git] Make `programs.git.extraConfig` more overrideable.
* [home-manager/Git] Enable commit signing by default only when the confkit GPG
    module is enabled.
* [home-manager/Zsh] Make the prompt work without Oh My Zsh.
* [home-manager/Zsh] Make Oh My Zsh an opt-in through `confkit.zsh.ohMyZsh`.
* [home-manager/root] Use the `confkit.zsh` module.
* [Zsh/Aliases] `oc` and `ocd` now expect the configuration to be in `/config`
    instead of `~/config`.
* [Zsh/Nix] Do not pre-build the configuration when running `snors`. The
    previous behaviour is usable through the `sbnors` alias.
* [Example] Simplify and update the example.
* [Example] Use the `home-manager` NixOS module.

### Removed

* [Nix] Remove the `confkit.modules.*` modules from `confkit/default.nix` since
    they are not needed for the new module system.
* [Nix] Remove the `confkit.file` function from `confkit/default.nix` since all
    installed files are now handled by the new configuration options from the
    NixOS and `home-manager` modules.
* [GPG] Remove `misc/gpg.conf` since it has been converted to a Nix module in
    `home-manager/modules/gpg.nix`.
* [Zsh/config/init.zsh] Remove as the minimum needed has been integrated in the
    `confkit.zsh` NixOS module.
* [Zsh/config/macos.zsh] Remove as it has been integrated in the `confkit.zsh`
    NixOS/nix-darwin module.

## [0.0.8] - 2020-06-14

### Added

* [Nix/Tmux] Add the `programs.tmux.useBepoKeybindings` option to opt-in for
    BÉPO-optimised keybindings.
* [Zsh/Elixir] Add `mck` for `mix check`.
* [ranger/bepo] Add `\.` for `fusermount -u %s`.
* [ranger] Add a QWERTY/AZERTY configuration, derived from both the default
    `rc.conf` and the BÉPO configuration from `confkit`.

### Changed

* [Nix/Environment] Do not create `/run/user/0` before to rebuild in `nors`.
* [Zsh/Nix] Do create `/run/user/0` before to rebuild in `snors`. This behaviour
    was here for a personal `TMPDIR` configuration, which I do not need anymore.
    Removing this also follows my will to avoid personal configuration in
    `confkit`.
* [ranger] Make the BÉPO configuration on par with the QWERTY/AZERTY one, mostly
    by adding and converting new shortcuts from upstream `rc.conf`. One notable
    change : `<ENTER>` now behaves as `r`, opening directories and files.
    Renaming from scratch is done with `hé` (like `cw` in the standard one).
* [Tmux] Remap the pane navigation keybindings for QWERTY/AZERTY. The previous
    one was optimised for BÉPO. The BÉPO keybindings are now in
    `tmux_bepo.conf`.

### Removed

* [Tmux] Remove the Tmux 2.3 configuration.

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

[Unreleased]: https://github.com/ejpcmac/confkit/compare/master..develop
[0.0.9]: https://github.com/ejpcmac/confkit/compare/v0.0.8...v0.0.9
[0.0.8]: https://github.com/ejpcmac/confkit/compare/v0.0.7...v0.0.8
[0.0.7]: https://github.com/ejpcmac/confkit/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/ejpcmac/confkit/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/ejpcmac/confkit/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/ejpcmac/confkit/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/ejpcmac/confkit/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/ejpcmac/confkit/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/ejpcmac/confkit/releases/tag/v0.0.1
