# confkit

`confkit` is a configuration framework using Nix. It is portable between NixOS,
other GNU/Linux distributions and macOS\*. It provides Nix modules to help
system and home configuration, including configuration for Nix, Zsh, tmux, Vim,
GPG and more. Parts of it can also be used outside of Nix to enable support for
systems unsupported by Nix, such as FreeBSD.

\* As I am currently using it only on NixOS and FreeBSD, this statement may be
untrue.

## Usage

### Setup

1. Create a directory for your own configuration files:

        $ sudo mkdir -m 700 /config
        $ sudo chown $UID:$GID /config

    You can choose another name for the directory, but `oc` and `ocd` aliases
    are defined to use this directory.

2. Optionally initialise a Git repository to track your configuration:

        $ cd /config
        $ git init

3. Add `confkit` and `home-manager` as submodules:

        $ git submodule add https://github.com/ejpcmac/confkit.git
        $ git submodule add https://github.com/rycee/home-manager.git

    If you are not using Git to track your configuration, do instead:

        $ git clone https://github.com/ejpcmac/confkit.git
        $ git clone https://github.com/rycee/home-manager.git

4. Switch to the `home-manager` branch matching your NixOS version, for
   instance:

        $ cd home-manager
        $ git checkout release-20.03

5. Copy the example in your own configuration:

        $ cd /config
        $ cp -r confkit/example/* .

In `Nix/`, you have now a `nixos-host` directory which contains a typical NixOS
configuration using `confkit`.

### Initial configuration

1. Rename the `nixos-host` directory to match your machine hostname. If you want
   to share some configuration between different machines, you can create a
   `common` directory and import `Nix/common/configuration.nix` in your
   different `Nix/<hostname>/configuration.nix`.

2. Edit your system configuration to match your needs. Don’t forget to configure
   your users in `Nix/<hostname>/users/default.nix`.

3. Copy / rename as necessary `Nix/<hostname>/users/user` to create
   `home-manager` configurations for your users. Don’t forget to update their
   imports in `Nix/<hostname>/users/default.nix`.

4. In `Nix/<hostname>/users/<username>/default.nix`, configure your identity
   information via `confkit.identity`, so it can be used by the `confkit.git`
   module. If you are using GPG, you can also define `confkit.identity.gpgKey`
   and enable the `confkit.gpg` module: it will also enable Git commit signing
   out of the box!

### Installation

On NixOS, link `/etc/nixos/configuration.nix` to
`/config/Nix/<hostname>/configuration.nix`.

## [Contributing](CONTRIBUTING.md)

Before contributing to this project, please read the
[CONTRIBUTING.md](CONTRIBUTING.md).

## License

Copyright © 2018-2020 Jean-Philippe Cugnet

[Do what the fuck you want to](LICENSE) with this project.
