#!/usr/bin/env bash
#
pushd ~/.config/dotfiles
export NIXPKGS_ALLOW_UNFREE=1

##nix build --extra-experimental-features nix-command   --extra-experimental-features flakes --impure .#homeManagerConfigurations.kayvan.activationPackage
nix build --impure .#homeManagerConfigurations.kayvan.activationPackage

./result/activate
popd
