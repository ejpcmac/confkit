# confkit

`confkit` is a configuration framework using Nix. It is portable between NixOS,
other GNU/Linux distributions and macOS. It provides Nix modules to help system
and home configuration, including for Nix, Zsh, tmux, Vim, GPG and more. Parts
of it can also be used outside of Nix to enable support for systems unsupported
by Nix, such as FreeBSD.

## Usage

### Setup

1. Create a directory for your own configuration files:

        $ mkdir -m 700 ~/config

    You can choose another name for the directory, but `oc` and `ocd` aliases
    are defined to use this directory.

2. Optionally initialise a Git repository to track your configuration:

        $ cd ~/config
        $ git init

3. Add `confkit` as submodule:

        $ git submodule add https://github.com/ejpcmac/confkit.git

    If you are not using Git to track your configuration, do instead:

        $ git clone https://github.com/ejpcmac/confkit.git

4. Copy the example in your own configuration:

        $ cp -r confkit/example/* .

In `Nix/`, you have now several directories:

* `common/`, which is aimed to contain modules which are common to all your
    machines;
* `*-host/` directories, which contains configuration files for typical NixOS,
    Darwin, and other Linux distributions with Nix installed in single-user
    mode.

### Initial configuration

1. Copy and rename the `*-host/` directories you need to match your different
    machines hostnames, then edit their system configuration. Don’t forget to
    configure your users if you are on NixOS.

2. In `common/home.nix`, replace `<fpr>` with your PGP key hash and configure
    your name and email for Git. You can also enable here diverse Zsh modules.

### Installation

Link:

* on NixOS, `/etc/nixos/configuration.nix` to
        `/path/to/nixos-host/configuration.nix`,
* on macOS, `~/.nixpkgs/darwin-configuration.nix` to
        `/path/to/darwin-host/darwin-configuration.nix`,
* on every platform for every user, `~/.config/nixpkgs/home.nix` to
        `/path/to/host/user.nix`.

## [Contributing](CONTRIBUTING.md)

Before contributing to this project, please read the
[CONTRIBUTING.md](CONTRIBUTING.md).

## License

Copyright © 2018-2019 Jean-Philippe Cugnet

[Do what the fuck you want to](LICENSE) with this project.
