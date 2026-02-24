{ pkgs, ... }:

{
  home.packages = [ pkgs.hyprpaper ];
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload=${../../../../wallpapers/aliegn-blue.jpg}
    wallpaper=,${../../../../wallpapers/aliegn-blue.jpg}
  '';
}
