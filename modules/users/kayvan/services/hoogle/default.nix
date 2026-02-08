{ config, lib, pkgs, ... }:

let cfg = config.services.hoogle;
name = "hoogle";
in
with lib;

{
  options.services.hoogle = with types; {
    enable = mkEnableOption "Hoogle server service";
  };
  config = let
    cfg = config.services.hoogle;
    mkStartScript = name: pkgs.writeShellScript "${name}.sh" ''
    set -euo pipefail
      ${pkgs.haskellPackages.hoogle}/bin/hoogle server --local --port 8666
    '';
  in
    # mkIf cfg.enable  {
    {
      systemd.user.services.hoogle = {
        Unit= {
          Description = "Hoogle service";
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
