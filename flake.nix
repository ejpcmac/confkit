{
  description = "An opinionated configuration framework using Nix.";

  outputs = inputs: {
    nixosModules = {
      # Modules.
      confkit-nixos = import ./nixos;
      confkit-home = import ./home-manager;

      # Home configurations.
      home-config-root = import ./home-manager/configs/root.nix;
    };
  };
}
