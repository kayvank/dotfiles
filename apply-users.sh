#!/usr/bin/env bash
#
pushd ~/.dotfiles
nix build .#homeManagerConfig.kayvan.activationPackage 
./result/activate
popd
