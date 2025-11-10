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
      texlivePackages.jetbrainsmono-otf
      source-sans
      source-sans-pro
      source-serif-pro
      source-code-pro
      material-design-icons
      noto-fonts-color-emoji
      twitter-color-emoji
      gentiu
      cantarell-fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.ubuntu-sans
    ];
  };
}
