####### Configuration for Nix ##################################################
##                                                                            ##
## * Enable store optimisation and sandboxing on non-Darwin hosts             ##
## * Keep derivations and build outputs (good for developers)                 ##
## * Use all the cores to build deviravions                                   ##
## * Automatically delete generations older than 30 days every day at 21:00   ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault optionalString;
  inherit (pkgs) stdenv;

  cfg = config.confkit.programs.nix;
in

{
  options.confkit.programs.nix = {
    enable = mkEnableOption "the confkit configuration for Nix";
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        cores = mkDefault 0;
        # TODO: Enable on Darwin when it is available.
        sandbox = mkDefault (! stdenv.isDarwin);

        # TODO: Enable everywhere once there is no race conditions.
        auto-optimise-store = mkDefault (! stdenv.isDarwin);
        keep-derivations = mkDefault true;
        keep-outputs = mkDefault true;
      };

      gc =
        let
          gc-common = {
            automatic = mkDefault true;
            options = mkDefault "--delete-older-than 30d";
          };
        in
        if stdenv.isDarwin then gc-common // {
          interval = mkDefault { Hour = 21; Minute = 0; };
        } else gc-common // {
          dates = mkDefault "21:00";
        };
    };
  };
}
