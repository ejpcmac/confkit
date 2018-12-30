{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    git
    gitAndTools.gitflow
  ];
}
