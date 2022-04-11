{ config, pkgs, lib, stdenv, ... }:
let
  defaultPkgs = with pkgs; [
    arandr               # simple GUI for xrandr
    awscli2
    autorandr
    blueman
    brave                # www browser
    dmenu                # application launcher
    docker-compose       # docker manager
    direnv               # customize env per directory
    discord
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
    neovim
    neofetch             # command-line system information
    nix-index            #  locate the package providing a certain file in nixpkgs
    pavucontrol          # pulseaudio volume control
    paprefs              # pulseaudio preferences
    pa_applet            # pulseaudio applet for trayer
    pasystray            # pulseaudio systray
    polybar
    python39Full
    prettyping           # a nicer ping
    pulsemixer           # pulseaudio mixer
    ranger               # terminal file explorer
    ripgrep              # fast grep
    rnix-lsp             # nix lsp server
    sqlite
    stalonetray
    slack                # messaging client
    terraform            # terraform
    tldr                 # summary of a man page
    tmux                 # tmux
    trayer
    tree                 # display files in a tree view
    volumeicon           # volume icon for trayer
    # virt-manager
    vscode
    xsel                 # clipboard support (also for neovim)

    # fixes the `ar` error required by cabal
    binutils-unwrapped
  ];
  home.stateVersion = "22.05";
  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    git-crypt     # git files encryption
    hub           # github command-line client
    tig           # diff and commit view
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

  programs.home-manager.enable = true;
  imports = (import ./programs) ++ (import ./services);

  xdg.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {

    packages =
      defaultPkgs ++
      gitPkgs ++
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


  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    # packageOverrides = p: {nur = import (import pinned/nur.nix) { inherit pkgs; };};
  };

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

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type file --follow"; # FZF_DEFAULT_COMMAND
      defaultOptions = [ "--height 20%" ]; # FZF_DEFAULT_OPTS
      fileWidgetCommand = "fd --type file --follow"; # FZF_CTRL_T_COMMAND
    };

    jq.enable = true;
    ssh = {
      enable = true;
      extraConfig = ''

        # Read more about SSH config files: https://linux.die.net/man/5/ssh_config
        Host dev
            HostName 173.198.252.23
            User soostone
        Host saturn-t480
            HostName 192.168.183.240
            User kayvan
        Host soostone-laptop
            HostName 192.168.183.229
            User soostone
      '';
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [];
    };


  };
}
