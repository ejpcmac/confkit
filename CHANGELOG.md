# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic
Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

* [NixOS/Features/Shell] Add `norb` as an alias to `nixos-rebuild boot`.
* [Zsh/Nix] Add `bnorb`, `snorb` and `sbnorb` as equivalent to `bnors`, `snors`
  and `sbnors`, but for `nixos-rebuild boot` instead of `nixos-rebuild switch`.

### Changed

* [home-manager/Git] Set the default branch name to `main`.
* [Zsh/ZFS] Show `canmount` property in `zl2` and `wzl2`.
* [Zsh/ZFS] Set the compression to `zstd` in `[s]zpcc`.

### Fixed

* [NixOS/Features/FileSystems] Fix the persistence for Chrony when `rootOnTmpfs`
    is set to `true`. The service from NixOS 20.09 wanted to set some properties
    to `/var/lib/chrony`, which was a symlink before this fix. As it does not
    work anymore with a symlink to `/persist/chrony`, we now mount directly the
    persistence file system to `/var/lib/chrony`.

## [0.0.12] - 2020-11-11

### Highlights

In addition to supporting NixOS 20.09, this new release brings a lot of new
features in the NixOS configuration module, as highlighted in the following
subsections. See the full changelog after the highlights for other minor
changes.

#### Configuration profiles

`confkit` now comes with out-of-the-box configuration profiles. You just have to
describe your machine type and usage to opt-in for the corresponding
configuration:

```nix
{
  confkit = {
    profile = {
      # Type can be "physical", "virtual", "container", "laptop".
      type = [ "physical" "laptop" ];

      # Usage can be "server" or "workstation".
      usage = [ "workstation" ];
    };
  };
}
```

See the configurations in `nixos/modules/profile/` for full details. You’ll note
that the `workstation` usage does not come with a pre-configured desktop
environment. This is on purpose. Configuration for such environment may come as
new *features* in future releases.

You can extend these profiles in your own configuration framework by creating a
conditional configuration module:

```nix
{ config, lib, pkgs, ... }:

{
  # Install Firefox on all your workstations.
  config = lib.mkIf (builtins.elem "workstation" config.confkit.profile.usage) {
    environment.systemPackages = [ pkgs.firefox ];
  };
}
```

If you have other machine types or usages, you can also register new types and
usages:

```nix
{
  confkit.extensions = {
    additionalTypes = [ "mainframe" "satellite" ];
    additionalUsages = [ "home" ];
  };
}
```

You can then define conditional configuration modules like for built-in types
and usages.

#### Machine info

In addition to configuration profiles, you can also now put relevent information
about your machine directly in your `confkit` configuration:

```nix
{
  confkit = {
    info = {
      name = "nixos-host";
      machineId = "c6dc57dbf4e9384215c6d0e6616d2ff2";
      location = "kerguelen";
    };
  };
}
```

If `name` is set, `confkit` configures `networking.hostName` for you. If
`machineId` is set, `confkit` sets the content of `/etc/machine-id` to it
declaratively, and also derives `networking.hostId` from its 8 fisrt characters.
The `location` is currently not used in `confkit` itself, but you can use this
information in your own configuration framework to perform location-dependant
configuration, for instance:

```nix
{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (config.confkit.info.location == "kerguelen") {
    location = {
      latitude = -49.35;
      longitude = 70.22;
    };

    time.timeZone = "Indian/Kerguelen";
  };
}
```

#### File systems configuration

In addition to the configuration profiles, `confkit` now ships with a
configuration for file systems intended for ZFS and btrfs users, inspired by
Graham Christensen’s [ZFS Datasets for
NixOS](https://grahamc.com/blog/nixos-on-zfs) article. It is an opt-in feature,
yet fully integrated with the profiles system, and comes in two flavours :
*persistent root* and *root on tmpfs*.

The persistent version uses the following layout:

```
root
├── local
│   ├── config (/config) (only on workstations)
│   ├── nix (/nix)
│   ├── tmp (/tmp)
│   └── var
│       ├── cache (/var/cache)
│       └── tmp (/var/tmp)
├── system
│   ├── ROOT (/)
│   ├── var (/var)
│   │   ├── db (/var/db)
│   │   ├── lib (/var/lib)
│   │   ├── log (/var/log)
│   │   └── spool (/var/spool)
│   └── root (/root)
└── user
    └── home (/home)
```

The `/config` mountpoint only exists in the `workstation` profile, because you
might prefer to use NixOps to push the configuration on other hosts. `/home` is
only configured for btrfs as for ZFS you might want to `zfs set
mountpoint=/home` so that all its child datasets are manager directly by the ZFS
subsystem.

When opting for / on tmpfs, confkit uses the following layout:

```
root
├── local
│   ├── config (/config) (only on workstations)
│   └── nix (/nix)
├── system
│   ├── data
│   │   ├── systemd (/persist/systemd)
│   │   ├── journal (/var/log/journal) (no symlink possible)
│   │   ├── utmp (/persist/utmp)
│   │   ├── chrony (/persist/chrony) (only on physical machines)
│   │   ├── sshd (/persist/sshd) (only on servers)
│   │   ...
│   └── root (/root)
└── user
    └── home (/home)
```

In this case, each service that needs persistence has its own dataset or
subvolume in `root/system/data/<service>`. It is generally mounted at
`/persist/<service>`, and the service configured to use this place. If the
service cannot be configured, a symlink to this directory / files is created
using `tmpfiles`. Finally, if the symlink is not an option, the dataset or
subvolume is mounted at the mandatory location.

This layout is fully integrated with the new `confkit` profile system: each
profile that configures services that needs persistence also configures the
relevent datasets. Please note that missing datasets are not created at the
moment, so you may need to create them yourself.

You can enable this new feature as follows:

```nix
{ config, lib, pkgs, ... }:

{
  confkit = {
    features = {
      fileSystems = {
        enable = true;  # Enable the configuration for file systems.
        fs = "zfs";     # Select the file system to use for the OS (ZFS/btrfs).

        # This partition is mounted on /boot. You do not need to set this
        # option if you use the default value.
        # bootPartition = "/dev/disk/by-label/boot";

        # By default, confkit assumes the system zpool name is the host name,
        # but you can override this behaviour.
        # zfs.zpool = config.networking.hostName;

        # If you are using btrfs, you need to set this option to some value.
        # btrfs.device = "/dev/disk/by-label/nixos";

        # You can also opt-in for /tmp on tmpfs, or even / on tmpfs.
        # tmpOnTmpfs = true;
        # rootOnTmpfs = true;
      };
    };
  };
}
```

You can extend this feature by adding new filesystem-agnostic datasets. For
instance, let’s say you want to extend the server profile with PostgreSQL:

```nix
{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (builtins.elem "server" config.confkit.profile.usage) {
    # Configure PostgreSQL to use a custom data directory.
    services.postgresql = {
      enable = true;
      dataDir = "/persist/postgresql/11";
    };

    fileSystems = {
      # Configure a persistent file system for PostgreSQL data.
      "/persist/postgresql" = pkgs.lib.confkit.mkFs config {
        # Translated to "<zpool>/system/data/postgresql" for ZFS and
        # "subvol=/system/data/todo" for btrfs.
        volumePath = "/system/data/postgresql";

        # These are the default values for other parameters you can pass to
        # mkFs.
        # options = [ "noatime" "nodev" "noexec" "nosuid" ];
        # neededForBoot = false;
      };
    };
  };
}
```

#### Bootloader configuration

To ease the configuration for simple bootloader cases, `confkit` provides a new
`bootloader` feature with higher-level concepts:

```nix
{
  confkit = {
    features = {
      bootloader = {
        enable = true;
        platform = "uefi"; # Can be "uefi" or "bios".
        bootloader = "systemd-boot"; # Can be "grub" or "systemd-boot".
        # device = "/dev/sda"; # Needed when using GRUB.
        # timeout = 1; # <- This is the default value.
      };
    };
  };
}
```

### Added

* [NixOS/Profile] Introduce `confkit.profile`, a module for out-of-the-box
    configuration profiles.
* [NixOS/Info] Introduce `confkit.info`, a configuration module to configure the
    machine name, ID and location.
* [NixOS/Features/Base] Add a `base` feature which make user immutable and use
    Zsh as default shell.
* [NixOS/Features/Bootloader] Add a `bootloader` feature with an out-of-the-box
    bootloader configuration depending on the platform (BIOS/UEFI) and program
    (GRUB/systemd-boot) to use.
* [NixOS/Features/FileSystems] Add a `filesystems` feature which configures base
    system filesystems/subvolumes with ZFS/btrfs. It is also possible to
    opt-in for a root on tmpfs by setting
    `confkit.features.filesystems.rootOnTmpfs` to true. In this case,
    per-application filesystems are configured and mounted under `/persist`.
    Configuration profiles from `confkit.profile` are aware of these options.
* [NixOS/Features/Intel] Add an `intel` feature which currently enables CPU
    microcode updates.
* [NixOS/Features/ZFS] Add a `zfs` feature which enables auto-snapshotting,
    auto-scrubbing and install Sanoid/Syncoid.
* [Zsh/Rust] Add `cicl` to install from the current path a statically-linked
    binary, using the `x86_64-unknown-linux-musl` target like in `cbl`.

### Changed

* **BREAKING**: [Zsh/Elixir] Update Distillery aliases for use with Distillery
    2.1+. This means `mrl[n|p|s|c|ca]` are now `mdrl[n|p|s|c|ca]`—note the
    added `d`—and call `mix distillery.release*`. An `mrl` alias has been kept
    for use with the built-in releases from Elixir 1.9+.

### Removed

* [NixOS] Drop support for NixOS 19.09.
* [NixOS/fonts] Remove Symbola since it has an unfree license.

### Fixed

* [NixOS/Features/Fonts] Add support for NixOS 20.09 by enabling penultimate
    only on NixOS 20.03.
* [NixOS/Programs/Tmux] Add support for NixOS 20.09 by removing the conditional
    on using `tmux.extraConfig` which was valid for NixOS 20.03 only. This drops
    support for NixOS 19.09.
* [Zsh/Elixir] Remove the `--verbose` flag from `mrl` so it works with the
    built-in `mix release` from Elixir 1.9+.

## [0.0.11] - 2020-10-04

### Added

* [Zsh/Nix] Add aliases for `nixos-container`.

### Changed

* **BREAKING**: [NixOS] Move `confkit.{fonts,shell,utilities}` under
    `confkit.features`.
* **BREAKING**: [NixOS] Move `confkit.{nix,ranger,tmux,vim,zsh}` under
    `confkit.programs`.
* **BREAKING**: [home-manager] Move
    `confkit.{git,gpg,pms,screen,tridactyl,zathura,zsh}` under
    `confkit.programs`.
* **BREAKING**: [NixOS & home-manager] Replace `confkit.keyboard.bepo` by
    `confkit.keyboard.layout`, wich can for now be set to `null` or `"bépo"`.
* [Zsh/direnv] Do not setup the shell hook as using the `programs.direnv`
    options from `home-manager` is now preferred.
* [Zsh/direnv] Make `dl` generic and straightforward by listing allowed `.envrc`
    directly from `$HOME/.local/share/direnv/allow`.
* [Zsh/direnv] Update `nixify` to just `use nix` in the project `.envrc`. Please
    use [`nix-direnv`](https://github.com/nix-community/nix-direnv) to enable
    cached shells globally.

### Removed

* [Zsh/direnv] Remove `drs` and `dcl` aliases which are now obsolete.

## [0.0.10] - 2020-08-30

### Added

* [NixOS/fonts] Add the option `confkit.fonts.enable` to enable a default
    configuration for fonts. This includes additional fonts from which you can
    opt-out by setting `confkit.fonts.installFonts` to `false`.
* [Zsh/Git] Add `gi` for `git init` and `gsa` for `git submodule add`.
* [Zsh/Git] Add more aliases for `hub` (see `zsh/git.zsh` for the full list).
* [Zsh/Rust] Add `cic` to install from the current path.
* [Zsh/Rust] Add `crr` for `cargo run --release`.
* [Zsh/Rust] Add `ce[r]` for `cargo embed [--release]`.

### Changed

* **BREAKING**: [Zsh/aliases] `e` Now opens the current directory with `codium`
    instead of `code`.
* **BREAKING**: [ranger/*] `E` now opens the current directory with `codium`
    instead of `code`.
* [home-manager/screen] Install `screen` when enabling the module.
* [Zsh/FreeBSD] Remove Tmux exclusion from `pma`.
* [Zsh/Rust] Update `cs` and `csr` to the new `cargo-binutils` interface.
* [Example] Reorganise the file layout and the sections inside the files.
* [Example] Use Chrony to sync the time instead of the NTP reference
    implementation.

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

* **BREAKING**: [Nix] Convert to a NixOS / home-manager module system. All
    modules now need to be enabled by setting `confkit.<module>.enable = true;`.
    These new configuration options are made available by importing
    `confkit/nixos` or `confkit/home-manager`.
* **BREAKING**: [NixOS/environment] Rename to shell.
* **BREAKING**: [NixOS/shell] Do not pre-build the configuration when running
    `nors`. The previous behaviour is now usable through the `bnors` alias,
    available in the Nix Zsh plugin, by adding `confkit.zsh.plugins = [ "nix"
    ];` to your home conifguration.
* **BREAKING**: [home-manager/Zsh] Make Oh My Zsh an opt-in through
  `confkit.zsh.ohMyZsh`.
* **BREAKING**: [Zsh/Aliases] `oc` and `ocd` now expect the configuration to be
    in `/config` instead of `~/config`.
* **BREAKING**: [Zsh/Nix] Do not pre-build the configuration when running
    `snors`. The previous behaviour is usable through the `sbnors` alias.
* [NixOS/shell] Bring in `nic{,l,a,r,u}` aliases from `confkit/zsh/nix.zsh`.
* [NixOS/Zsh] Enable syntax highlighting.
* [home-manager/Git] Make `programs.git.extraConfig` more overrideable.
* [home-manager/Git] Enable commit signing by default only when the confkit GPG
    module is enabled.
* [home-manager/Zsh] Make the prompt work without Oh My Zsh.
* [home-manager/root] Use the `confkit.zsh` module.
* [Example] Simplify and update the example.
* [Example] Use the `home-manager` NixOS module.

### Removed

* **BREAKING**: [Nix] Remove the `confkit.modules.*` modules from
    `confkit/default.nix` since they are not needed for the new module system.
* **BREAKING**: [Nix] Remove the `confkit.file` function from
    `confkit/default.nix` since all installed files are now handled by the new
    configuration options from the NixOS and `home-manager` modules.
* **BREAKING**: [GPG] Remove `misc/gpg.conf` since it has been converted to a
    Nix module in `home-manager/modules/gpg.nix`.
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

* **BREAKING**: [Nix/Environment] Do not create `/run/user/0` before to rebuild
    in `nors`.
* **BREAKING**: [Zsh/Nix] Do create `/run/user/0` before to rebuild in `snors`.
    This behaviour was here for a personal `TMPDIR` configuration, which I do
    not need anymore. Removing this also follows my will to avoid personal
    configuration in `confkit`.
* **BREAKING**: [ranger] Make the BÉPO configuration on par with the
    QWERTY/AZERTY one, mostly by adding and converting new shortcuts from
    upstream `rc.conf`. One notable change : `<ENTER>` now behaves as `r`,
    opening directories and files. Renaming from scratch is done with `hé` (like
    `cw` in the standard one).
* **BREAKING**: [Tmux] Remap the pane navigation keybindings for QWERTY/AZERTY.
    The previous one was optimised for BÉPO. The BÉPO keybindings are now in
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

* [Zsh/ZFS] Set `reservation=1G` when creating a pool with `zpcc`.
* [Zsh/ZFS] Set `ashift=12` when creating a pool with `zpcc`.
* [Zsh/ZFS] Add a `recordsize` column to `zl2`.

### Removed

* [Nix/Utilities] Comment out `vulnix` since one of its dependencies
    (`python-ZODB`) is broken on NixOS 20.03.

### Fixed

* [Nix/tmux] Add support for NixOS 20.03 by using `tmux.extraConfig`. NixOS
    19.09 is still supported.

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

* **BREAKING**: [Zsh/direnv] Make `dl` look at `~/Informatique` instead of
    `~/Programmes` and add a comment to make clear it is provided as an example.
* **BREAKING**: [ranger/bepo] Open the current directory with Emacs on `e`.
* [Nix/Environment] Create the `$TMPDIR` before to rebuild in `nors`.
* [Zsh/Nix] Create the `$TMPDIR` before to rebuild in `snors`.
* [Zsh/Rust] Change `cia`: remove `cargo-vendor`, `cargo-geiger` and
    `cargo-audit`, add `cargo-crev`.
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

* **BREAKING**: [Zsh/Aliases] Change `oc` and `ocd` to use `~/config` instead of
    `~/config_files`.
* **BREAKING**: [ranger] Rename `ranger/rc.conf` to `ranger/bepo_rc.conf`.
* **BREAKING**: [ranger/bepo] Use `\\` to unmount as user, `\!` as root.
* [Nix/Tmux] Install tmuxinator automatically.
* [Zsh/dev] Update `pgst` to put the socket in $PGDATA.
* [Zsh/Rust] Add cargo-generate and cargo-binutils installation to `cia`.

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

* **BREAKING**: [Zsh/zshrc] Automatically choose the editor in the out-of-Nix
    system `zshrc`. The default editor is Emacs, using the deamon. If it is not
    available or the daemon is not started, falls back to vim, then nano, then
    ee, then vi. For this to work, `scripts/open-editor` must be installed in
    `/usr/bin`.
* **BREAKING**: [Zsh/Aliases] Use Emacs to edit the configuration.
* **BREAKING**: [Zsh/Aliases] Move PostgreSQL aliases to the `dev` module.
* **BREAKING**: [Tmux] Update the pane navigation to be a bit more Vim-like.
    * Use `C-<c,t,s,r>` to move btween panes and `C-<v/q,n>` to move between
      windows.
* [Zsh/Elixir] Update the Nerves aliases to push firmwares.

### Removed

* **BREAKING**: [Nix/xserver] Remove common configuration.

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

[Unreleased]: https://github.com/ejpcmac/confkit/compare/main...develop
[0.0.12]: https://github.com/ejpcmac/confkit/compare/v0.0.11...v0.0.12
[0.0.11]: https://github.com/ejpcmac/confkit/compare/v0.0.10...v0.0.11
[0.0.10]: https://github.com/ejpcmac/confkit/compare/v0.0.9...v0.0.10
[0.0.9]: https://github.com/ejpcmac/confkit/compare/v0.0.8...v0.0.9
[0.0.8]: https://github.com/ejpcmac/confkit/compare/v0.0.7...v0.0.8
[0.0.7]: https://github.com/ejpcmac/confkit/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/ejpcmac/confkit/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/ejpcmac/confkit/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/ejpcmac/confkit/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/ejpcmac/confkit/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/ejpcmac/confkit/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/ejpcmac/confkit/releases/tag/v0.0.1
