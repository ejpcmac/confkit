# confkit

`confkit` is an opinionated and extensible configuration framework using Nix. It
provides NixOS and `home-manager` modules for a better out-of-the-box
experience. Parts of it can also be used outside of Nix to enable support for
systems unsupported by Nix, such as FreeBSD.

You can find an example of usage in the `example/` directory. As a more
complete, but also more complex example, you can check [my public config
repo](https://github.com/ejpcmac/config).

## Stability status

Since the long due refactor to a NixOS / `home-manager` module system has been
done, `confkit` should be more stable than ever in its public interface. The
exact configuration inside a module can still change though, and the new
interface is still young: I may find something wrongly designed and break things
to enhance it. That’s why `confkit` is still at 0.0.x. Before to release confkit
0.1.0, I need to:

* remove some hacky things,
* remove the last really personal preferences,
* add a proper documentation.

If you find it useful, you can use it and even help me to reach a more stable
state :) If I am aware of people using it, I’ll try not to introduce breaking
changes in a too harsh way.

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

3. Initialise the configuraton using the template provided by `confkit`:

        nix flake init -t github:ejpcmac/confkit

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

## Supported NixOS versions

`confkit` currently supports NixOS 23.11.

## [Contributing](CONTRIBUTING.md)

Before contributing to this project, please read the
[CONTRIBUTING.md](CONTRIBUTING.md).

## License

Copyright © 2018-2023 Jean-Philippe Cugnet

[Do what the fuck you want to](LICENSE) with this project.
