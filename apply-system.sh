#!/usr/bin/env bash

pushd ~/.config/dotfiles
sudo nixos-rebuild switch  --flake .#
popd
