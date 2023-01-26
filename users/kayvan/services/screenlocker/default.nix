{ pkgs, ... }:

{
  services.screen-locker = {
    enable = true;
    inactiveInterval = 59; ## min=1min, max=1 hour, defult=10min
    lockCmd = "${pkgs.multilockscreen}/bin/multilockscreen -l dim";
#    xautolock.extraOptions = [ "Xautolock.killer: systemctl suspend" ];
  };
}
