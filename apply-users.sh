#!/usr/bin/env bash
#
pushd ~/.dotfiles
export NIXPKGS_ALLOW_UNFREE=1
nix build --impure .#homeManagerConfigurations.kayvan.activationPackage
./result/activate
popd
