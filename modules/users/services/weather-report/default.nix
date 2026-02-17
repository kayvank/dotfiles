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
        OnBootSec = "2m"; ## run 2 min after boot up
        OnUnitActiveSec = "4h"; ## run 4 hours after the last run
        # OnCalendar = "hourly";
        Unit = "${name}.service";
      };
      Install = {
        WantedBy = ["timers.target"];
      };

    };

  };



}
