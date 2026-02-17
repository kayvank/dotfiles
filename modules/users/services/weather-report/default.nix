{ config, lib, pkgs, ... }:
let
  name = "weather-report";
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    requests
    typing-extensions
  ]);
  scriptPath = ../../scripts/UserScripts/Weather.py;


in
{
  systemd.user = {

    services."${name}" = {
      Unit = {
        description = "Weather Report Service";
        wahtedBy = ["default.target"];
      };

      Service = {
        ExecStart = "${pythonEnv}/bin/python3 ${scriptPath}";
        type = "oneshot";
        enable = true;
      };
      Install = {
        wahtedBy = ["default.target"];
      };

      # Explicitly use the defined python environment to run the script
      serviceConfig = {
        type = "oneshot";
      };
    };

    timers."${name}" = {
      Unit = {
        Description = "${name} timer";
      };
      Timer = {
        # onBootSec = "5m";
        # onUnitActiveSec = "5h";
        OnCalendar = "hourly";
        Unit = "${name}.service";
      };
      Install = {
        WantedBy = ["timers.target"];
      };

      # timerConfig = {
      #   Unit = "${name}.service";
      #   OnCalendar = "daily"; # Runs once a day at 12:00 am
      #   Persistent = true;    # Ensures the job runs if a start time was missed (e.g., system off)
      #   description = "Timer for ${name}-service";
      #   };

    };

  };



}
