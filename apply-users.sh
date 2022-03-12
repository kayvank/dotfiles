#!/usr/bin/env bash
#
pushd ~/.dotfiles
nix build .#homeManagerConfigurations.kayvan.activationPackage
./result/activate
popd
