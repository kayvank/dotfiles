{ config, lib, pkgs, ... }:
{

  imports = [
    ./zsh.nix
    ./tmux
    ./kitty
    ./git
  ];
}
