{
  config,
  lib,
  pkgs,
  inputs, ...
}:

let
  cfg = config.systemSettings.hyprland;
in {
  options = {
    systemSettings.hyprland = {
      enable = lib.mkEnableOption "Enable hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    # Power key should not shut off computer by defaultPower key shuts of
    services.logind.powerKey = "suspend";


    programs.hyprland = {
      enable=true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland; # xdph none git

    };


  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  };
}
