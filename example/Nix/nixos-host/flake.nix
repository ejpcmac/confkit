{
  description = "The configuration for nixos-host.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    confkit.url = "github:ejpcmac/confkit/v0.0.18";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs: {
    nixosConfigurations.nixos-host = inputs.nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs system; };

      modules = [
        ./configuration.nix

        {
          home-manager.extraSpecialArgs = { inherit inputs system; };
        }
      ];
    };

    # This allows to run `nix build` in the directory to build the configuration.
    defaultPackage.x86_64-linux = self.nixosConfigurations.nixos-host.config.system.build.toplevel;
  };
}
