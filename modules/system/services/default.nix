{ config, lib, pkgs, ... }:

{
  services = {
    xserver.videoDrivers = ["nvidia"];
    gnome.gnome-keyring.enable = false;

    upower.enable = true;

    blueman.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
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

}
