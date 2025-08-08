{ config, lib, pkgs, ... }:

{
   fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Gentium" ];
        sansSerif = [ "Cantarell" ];
        monospace = [ "Source Code Pro" ];
        emoji = [ "Twitter Color Emoji" ];



      };
    };
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      font-awesome
      iosevka
      source-sans-pro
      source-serif-pro
      source-code-pro
      noto-fonts-color-emoji
      twitter-color-emoji
      gentiu
      cantarell-fonts
      jetbrains-mono
    ];
  };
}
