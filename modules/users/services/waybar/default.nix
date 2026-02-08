{ config, lib, pkgs, ... }:
let
  cfg = config.services.waybar;
  name = "waybar";
  in
  with lib;
{
  options.services.waybar = with types; {
    enable = mkEnableOption "Waybar status bar for Wayland";
  };
  config = let
    mkStartScript = name: pkgs.writeShellScript "${name}.sh" ''
      set -euo pipefail
      ${pkgs.waybar}/bin/waybar
    '';
  in
    mkIf cfg.enable  {
      systemd.user.services.waybar = {
        Unit= {
          Description = "Waybar service";
          WantedBy = [ "default.target" ];
        };
        Service = {
          ExecStart = "${mkStartScript name}";
          Type = "simple";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
}
