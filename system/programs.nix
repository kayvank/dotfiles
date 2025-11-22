{ config, lib, pkgs, ... }:

{
  xdg.portal = {
    enable = true;
    config.common.default = ["hyprland"];
  };

  programs = {
    light.enable = true;
    mtr.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
  };

}
