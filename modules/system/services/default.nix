{ config, lib, pkgs, ... }:

{
  services = {
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

    cron = {
      enable = true;
      systemCronJobs = [
        # Run weahter report as kayvan every 4 hours
        "0 */4 * * * kayvan $HOME/.config/scripts/UserScripts/WeatherWrap.sh"
      ];
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
