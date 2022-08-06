{ config, pkgs, lib, stdenv, ... }:
let
  defaultPkgs = with pkgs; [
    arandr               # simple GUI for xrandr
    awscli2
    aws-mfa
    blueman
    brave                # www browser
    dmenu                # application launcher
    docker-compose       # docker manager
    #  direnv               # customize env per directory
    evince
    exa                  # a better `ls`
    fd                   # "find" for files
    feh                  # image viewer
    gimp                 # gnu image manipulation program
    glow                 # terminal markdown viewer
    ispell               # An interactive spell-checking program for Unix usec by emacs
    killall              # kill processes by name
    libnotify            # notify-send command
    multilockscreen      # fast lockscreen based on i3lock
    cinnamon.nemo        # file explorer
    neofetch             # command-line system information
    pavucontrol          # pulseaudio volume control
    paprefs              # pulseaudio preferences
    pa_applet            # pulseaudio applet for trayer
    pasystray            # pulseaudio systray
    python39Full
    prettyping           # a nicer ping
    pulsemixer           # pulseaudio mixer
    ranger               # terminal file explorer
    ripgrep              # fast grep
    rnix-lsp             # nix lsp server
    sbcl
    stalonetray
    slack                # messaging client
    sqlite
    terraform            # terraform
    tldr                 # summary of a man page
    tmux                 # tmux
    tree                 # display files in a tree view
    usbutils
    volumeicon           # volume icon for trayer
    virt-manager
    vscode
    xclip
    xsel                 # clipboard support (also for neovim)
    gnome.gnome-disk-utility

    # fixes the `ar` error required by cabal
    binutils-unwrapped
  ];

  haskellPkgs = with pkgs.haskellPackages; [
    cabal2nix               # convert cabal projects to nix
    cabal-install           # package manager
    ghc                     # compiler
    ghcid                   # ghcid for continues build
    haskell-language-server # haskell IDE (ships with ghcide)
    dhall-lsp-server
    hoogle                  # documentation
    hlint
    nix-tree                # visualize nix dependencies
    ormolu
    stylish-haskell
    stack
    termonad
    xmobar
  ];

  xmonadPkgs = with pkgs; [
    networkmanager_dmenu   # networkmanager on dmenu
    networkmanagerapplet   # networkmanager applet
    nitrogen               # wallpaper manager
    xcape                  # keymaps modifier
    xorg.xkbcomp           # keymaps modifier
    xorg.xmodmap           # keymaps modifier
    xorg.xrandr            # display manager (X Resize and Rotate protocol)
    xorg.xdpyinfo
  ];

in
{

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };
  programs.home-manager.enable = true;
  imports = (import ./programs) ++ (import ./services);

  xdg.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    packages =
      defaultPkgs ++
      ##gitPkgs ++
      haskellPkgs ++
      xmonadPkgs
      ;

      sessionVariables = {
        DISPLAY = ":0";
        EDITOR = "vim";
      };
  };
  # notifications about home-manager news
  news.display = "silent";


  # Let Home Manager install and manage itself.
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";

  # notifications about home-manager news


  services = {
    flameshot.enable = true;
  };

  programs = {

    zsh =  {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" "kubectl" ];
      };
    };

    tmux.enable = true;
    emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
      ];
    };

    git = {
      enable = true;
      userName = "kayvank";
      userEmail = "kayvan@q2io.com";
      # signing = "60969F8A84531894";
      # commit = {gpgSign = true;};
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };

    htop = {
      enable = true;
      settings = {
        sort_direction = true;
        sort_key = "PERCENT_CPU";
      };
    };

    bat.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      #  nix-direnv.enable = true;
    };

    jq.enable = true;
    ssh.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [];
    };


  };
}
