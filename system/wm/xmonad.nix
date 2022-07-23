{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };


  systemd.services.upower.enable = true;
}

