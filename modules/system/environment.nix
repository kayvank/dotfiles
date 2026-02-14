{ config, lib, pkgs, ... }:

{

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    cachix
    dict
    dunst
    git
    go
    grim # screenshot functionality
    home-manager
    kitty
    libnotify
    libvirt
    mako # notification system developed by swaywm maintainer
    pciutils
    qemu
    slurp # screenshot functionality
    swww # wallpaper
    udiskie
    virt-manager
    vim
    # waybar
    wget
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wofi
    pastel ## integration with GNOME terminal
    xclip
    xorg.xbacklight
    hunspell
    hunspellDicts.en_US
    aspell
    aspellDicts.en
    (aspellWithDicts
          (dicts: with dicts; [
            de en en-computers en-science es fr la ]))
    scowl
    gnome-terminal
    gpaste

# Link to a standard location if required by tools


  ];
  environment.etc."scowl-dict".source = "${pkgs.scowl}/share/dict";
}
