let
  extend-stdlib = self: super: {
    lib = super.lib // { confkit = import ./.; };
  };
in

{
  nixpkgs.overlays = [ extend-stdlib ];
}
