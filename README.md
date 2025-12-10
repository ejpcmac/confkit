# confkit

`confkit` is an opinionated and extensible configuration framework using Nix. It
provides NixOS and `home-manager` modules for a better out-of-the-box
experience. Parts of it can also be used outside of Nix to enable support for
systems unsupported by Nix, such as FreeBSD.

You can find an example of usage in the `example/` directory. As a more
complete, but also more complex example, you can check [my public config
repo](https://github.com/ejpcmac/config).

## Releases

`confkit` follows a rolling release scheme with stability guarantees. For each
supported NixOS version, it comes with two levels of stability:

* `stable` can be updated with new features and fixes but no breaking changes,
* `develop` can contain breaking changes.

The currently supported branches are:

* [`stable-25.11`](https://github.com/ejpcmac/confkit/tree/stable-25.11) —
    stable channel compatible with NixOS 25.11
    ([changelog](https://github.com/ejpcmac/confkit/blob/stable-25.11/CHANGELOG.md)),
* [`develop-25.11`](https://github.com/ejpcmac/confkit/tree/develop-25.11) —
    development channel compatible with NixOS 25.11
    ([changelog](https://github.com/ejpcmac/confkit/blob/develop-25.11/CHANGELOG.md)).

When a new version of NixOS is supported, the `develop` channel from the
previous version is promoted to `stable`.

## Usage

### Setup

1. Create a directory for your own configuration files:

        sudo mkdir -m 700 /config
        sudo chown $UID:$GID /config

    You can choose another name for the directory, but `oc` and `ocd` aliases
    are defined to use this directory.

2. Initialise a Git repository to track your configuration:

        cd /config
        git init

3. Initialise the configuration using the template provided by `confkit`:

        nix flake init -t github:ejpcmac/confkit/stable-25.11

In `Nix/`, you have now a `nixos-host` directory which contains a typical NixOS
flake configuration using `confkit`.

### Initial configuration

1. Rename the `Nix/nixos-host` directory to match the hostname of your machine.
   If you want to share some configuration between different machines, you can
   create a `common` directory and import `Nix/common/configuration.nix` in your
   different `Nix/<hostname>/configuration.nix`.

2. Edit the system configuration in `Nix/<hostname>/configuration.nix` to match
   your needs. Don’t forget to review all the TODOs.

3. Copy / rename as necessary `Nix/<hostname>/users/user` to create
   `home-manager` configurations for your users. Don’t forget to update their
   imports in `Nix/<hostname>/configuration.nix`.

4. In `Nix/<hostname>/users/<username>/home.nix`, configure your identity
   information via `confkit.identity`, so it can be used by the `confkit.git`
   module. If you are using GPG, you can also define `confkit.identity.gpgKey`
   and enable the `confkit.gpg` module: it will also enable Git commit signing
   out of the box!

### Installation

On NixOS:

1. link `/etc/nixos/flake.nix` to `/config/Nix/<hostname>/flake.nix`,
2. run `sudo nixos-rebuild switch`.

## [Contributing](CONTRIBUTING.md)

Before contributing to this project, please read the
[CONTRIBUTING.md](CONTRIBUTING.md).

## License

Copyright © 2018-2026 Jean-Philippe Cugnet

[Do what the fuck you want to](LICENSE) with this project.
