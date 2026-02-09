{ pkgs, ... }:

{
  home.packages = [ pkgs.hyprpaper ];
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload=${./wallpapers/night-monochrome.jpg}
    wallpaper=,${./wallpapers/night-monochrome.jpg}
  '';
}
