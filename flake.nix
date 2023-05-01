{
  description = "An opinionated configuration framework using Nix.";

  outputs = { self, ... }: {
    nixosModules = {
      # Modules.
      confkit-nixos = import ./nixos;
      confkit-home = import ./home-manager;

      # Home configurations.
      home-config-root = import ./home-manager/configs/root.nix;
    };

    templates = {
      default = self.templates.config;

      config = {
        path = ./example;
        description = "A configuration using confkit.";

        welcomeText = ''
          # Welcome to confkit

          Congratulations, you have just initialised a NixOS configuration using
          `confkit`. Follow the instructions to get started.

          ## Initial configuration

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

          5. Commit your configuration:

                  cd /config
                  git add .
                  git commit -m "initial commit"

          ### Installation

          1. Link `/etc/nixos/flake.nix` to `/config/Nix/<hostname>/flake.nix`.
          2. Run `sudo nixos-rebuild switch`.
        '';
      };
    };
  };
}
