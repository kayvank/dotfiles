{ config, pkgs, lib, stdenv, ... }:
let
  defaultPkgs = with pkgs; [
    arandr               # simple GUI for xrandr
    aspell
    awscli2
    aws-mfa              # Manage AWS MFA Security Credentials
    brightnessctl        ## Xbacklight (Hardware Level)
    blueman
    brave                # www browser
    # dmenu                # application launcher
    docker-compose       # docker manager
    direnv               # customize env per directory
    discord
    evince
    exa                  # a better `ls`
    fd                   # "find" for files
    feh                  # image viewer
    file
    google-cloud-sdk
    gimp                 # gnu image manipulation program
    glow                 # terminal markdown viewer
    graphviz
    ispell               # An interactive spell-checking program for Unix usec by emacs
    killall              # kill processes by name
    libnotify            # notify-send command
    multilockscreen      # fast lockscreen based on i3lock
    cinnamon.nemo        # file explorer
    neovim
    neofetch             # command-line system information
    nixfmt
    nix-index            #  locate the package providing a certain file in nixpkgs
    nodejs
    # pavucontrol          # pulseaudio volume control
    # paprefs              # pulseaudio preferences
    pa_applet            # pulseaudio applet for trayer
    # pasystray            # pulseaudio systray
    pgadmin4
    polybar
    python39Full
    prettyping           # a nicer ping
    # pulsemixer           # pulseaudio mixer
    ranger               # terminal file explorer
    rtags
    redis
    ripgrep              # fast grep
    rnix-lsp             # nix lsp server
    sbcl
    sqlite
    stalonetray
    slack                # messaging client
    terraform            # terraform
    # tldr                 # summary of a man page
    tmux                 # tmux
    trayer
    tree                 # display files in a tree view
    volumeicon           # volume icon for trayer
    virt-manager
    virt-viewer
    vscode
    xsel                 # clipboard support (also for neovim)
    xclip
    yarn

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
    implicit-hie
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
    lorri.enable = true;
    nixos-vscode-ssh-fix.enable = true;
  };

  programs = {

    zsh =  {
      enable = true;
      oh-my-zsh = {enable = true; plugins = [ "git" "sudo" "docker" "kubectl" ];};
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
      # enableBashIntegration = true;
      enableZshIntegration = true;
       nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      # enableBashIntegration = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type file --follow"; # FZF_DEFAULT_COMMAND
      defaultOptions = [ "--height 20%" ]; # FZF_DEFAULT_OPTS
      fileWidgetCommand = "fd --type file --follow"; # FZF_CTRL_T_COMMAND
    };

    jq.enable = true;
    ssh = {
      enable = true;
      extraConfig = ''
      Host *
      ControlMaster auto
      ControlPath /tmp/%r@%h:%p
      ControlPersist 2h
      # Read more about SSH config files: https://linux.die.net/man/5/ssh_config
      Host dev-saturn
      HostName 66.206.39.66
      User kayvan
      Host saturn-t480
      HostName 192.168.183.240
      User kayvan
      Host soostone-laptop
      HostName 192.168.183.229
      User soostone
      Host saturn-dev-ubuntu
      HostName 192.168.122.112
      User kayvan
      Host saturn-dev-suse
      HostName 192.168.122.182
      User kayvan
    '';
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      # enableBashIntegration = true;
      options = [];
    };


  };
}
