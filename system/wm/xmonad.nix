{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  systemd.services.upower.enable = true;

}
