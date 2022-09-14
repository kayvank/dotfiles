{ config, pkgs, lib, stdenv, ... }:
let
  username = "kayvan";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  defaultPkgs = with pkgs; [
    amazon-ecs-cli       # amazon ecs client
    arandr               # simple GUI for xrandr
    mate.atril
    aspell
    aspellDicts.en       # Aspell dictionary for English
    awscli2
    aws-mfa              # Manage AWS MFA Security Credentials
    bashmount            # mount usb
    brightnessctl        # Xbacklight (Hardware Level)
    blueman              # GTK-based Bluetooth Manager
    brave                # www browser
    docker-compose       # docker manager
    direnv               # customize env per directory
    element              #  Periodic table
    element-desktop      #  A feature-rich client for Matrix.org
    # evince               # gnume document viewer
    exa                  # a better `ls`
    fd                   # "find" for files
    feh                  # image viewer
    file                 # light weight image viewer
    google-cloud-sdk     # gcp sdk
    # google-chrome        # google web browser
    google-drive-ocamlfuse # mount your Google Drive
    grafana
    gimp                 # gnu image manipulation program
    glow                 # terminal markdown viewer
    gnumake              #  A tool to control the generation of non-source files from sources
    graphviz             # grapsh visualization tool
    irony-server         # c/c++ minor mode, emacs
    ispell               # An interactive spell-checking program for Unix usec by emacs
    killall              # kill processes by name
    libnotify            # notify-send command
    multilockscreen      # fast lockscreen based on i3lock
    cinnamon.nemo        # file explorer
    neofetch             # command-line system information
    nixfmt
    nix-index            #  locate the package providing a certain file in nixpkgs
    pa_applet            # pulseaudio applet for trayer
    pgadmin4             # postgres admin
    polybar
    python39Full         # pythong
    prettyping           # a nicer ping
    ranger               # terminal file explorer
    rtags                # C/C++ client-server indexer based on clang
    redis                # redis
    ripgrep              # fast grep
    rnix-lsp             # nix lsp server
    sbcl                 # lisp compiler
    sqlite               # db sqlite
    signal-desktop       # encrypted com
    starship             # zsh prompt
    slack                # messaging client
    terraform            # terraform
    tree                 # display files in a tree view
    usbutils             # Tools for working with USB devices, such as lsusb
    volumeicon           # volume icon for trayer
    virt-manager         # mange vms
    virt-viewer          # view vmx
    vscode               # ms visual studio
    xsel                 # clipboard support (also for neovim)
    xclip                # copy pate like mac does
    yarn                 # js build
    zip                  # zip archive

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
    hindent
    implicit-hie
    stack
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

  xdg = {
    inherit configHome;
    enable = true;
  };
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {

    packages =
      defaultPkgs ++
      gitPkgs ++
      haskellPkgs ++
      xmonadPkgs ;

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
  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
    flameshot.enable = true;
    trayer = {
      enable = true;
      settings = {

        edge = "top";
        align = "right";
        SetDockType  = true;
        SetPartialStrut = true;
        expand = true;
        transparent = true;
        width = 5;
        height=15;
        tint = "black";
      };
    };
  };
  # restart services on change
  systemd.user.startServices = "sd-switch";

  programs = {
    bash.enable = false;
    emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
      ];
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
      nix-direnv.enable = true;
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
#
        Host saturn-vm
        HostName 192.168.183.188
        User kayvan
#
        Host saturn-t480
        HostName 192.168.183.240
        User kayvan
#
        Host saturn-xeon
        HostName 192.168.183.166
        User kayvan
#
        Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_rsa_q2io
        IdentitiesOnly yes
##
## see  https://docs.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate?view=azure-devops#q-i-have-multiple-ssh-keys--how-do-i-use-different-ssh-keys-for-different-ssh-servers-or-repos
##
        Host ssh.dev.azure.com
        HostName ssh.dev.azure.com
        User git
        PubkeyAcceptedAlgorithms +ssh-rsa
        HostkeyAlgorithms +ssh-rsa
        IdentityFile ~/.ssh/id_rsa_umbrage
        IdentitiesOnly yes
      '';
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [];
    };
  }; ## program

}
