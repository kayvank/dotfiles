{ config, lib, pkgs, ... }:
{

  imports = [
    ./zsh.nix
    ./fish
  ];
}
