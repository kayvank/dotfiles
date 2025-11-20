{config, lib, pkgs,inputs, ... }:

{
  programs.hyprland = {
  enable=true;
  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  xwayland.enable = true;
  withUWSM = false;
  portalPackage = pkgs.xdg-desktop-portal-hyprland; # xdph none git
  };
  environment.sessionVariables = {
   NIXOS_OZONE_WL = "1";
   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
