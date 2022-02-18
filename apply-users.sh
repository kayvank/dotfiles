#!/usr/bin/env bash
#
pushd ~/.dotfiles
nix build .#homeManagerConfigurations.soostone.activationPackage 
./result/activate
popd
