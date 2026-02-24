{ config, lib, pkgs, ... }:

{
  services = {
    qemuGuest.enable = true;
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      # desktopManager.gnome.enable = true;
    };

    gnome.gnome-keyring.enable = false;

    upower.enable = true;

    blueman.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf  pkgs.gpaste];
    };

    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

  };
  systemd.user.services.gpaste = {
    description = "GPaste clipboard manager";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.gpaste}/libexec/gpaste/gpaste-daemon";
    };
  };
}
