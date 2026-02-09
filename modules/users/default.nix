{ config, pkgs, lib, stdenv,inputs, ... }:
let
  username = "kayvan";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  screenCapture = pkgs.pkgs.writeShellScriptBin "start" ''
    DIR_PATH=$HOME/Pictures/Screenshots
    mkdir -p $DIR_PATH
    FILE_PATH=$DIR_PATH/$(date +'%s_grim.png')
    grim -g "$(slurp)" $FILE_PATH
    imv $FILE_PATH
'';

  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    # ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &

/   sleep 1

    ${pkgs.swww}/bin/swww img ${./wallpapers/saturn.jpg} &
  '';


  fontPkgs = with pkgs; [
    font-awesome # awesome fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.space-mono
    nerd-fonts.ubuntu-mono
    nerd-fonts.symbols-only
    nerd-fonts.geist-mono
    nerd-fonts.inconsolata
    nerd-fonts.iosevka
    material-design-icons # fonts with glyphs
  ];

  audioPkgs = with pkgs; [
    paprefs # pulseaudio preferences
    pasystray # pulseaudio systray
    pavucontrol # pulseaudio volume control
    playerctl # music player controller
    pulsemixer # pulseaudio mixer
  ];

  defaultPkgs = with pkgs; [
    texlive.combined.scheme-full  # latex
    asdf-vm
    arandr               # simple GUI for xrandr
    mate.atril           # A simple multi-page document viewer
    aspell
    aspellDicts.en       # Aspell dictionary for English
    bfg-repo-cleaner     # git repository cleaner
    bgs # Extremely fast and small background setter for X

	  bemenu #  	#App launcher
    brightnessctl        # Xbacklight (Hardware Level)
    buku                # bookmark manager
    cmake
    code-cursor          # cursor ai tool
    cowsay               # cow shell ouput
    # chromium             ## google open source browser
    discord
    docker-compose       # docker manager
    duf                  # disk utility
    devenv               # A simple multi-page document viewer
    direnv               # customize env per directory
    evince               # document viewer, pdf viewer
    eza                  # a better `ls`
    fd                   # "find" for files
    feh                  # image viewer
    file                 # light weight image viewer
    firefox             # web browser
    flamegraph           # performance profiling
    gcc                  # C/C++
    gh                   # github CLI tool
    gimp                 # gnu image manipulation program
    glow                 # terminal markdown viewer
    gnumake              # A tool to control the generation of non-source files from sources
    grim                 # screenshots
    graphviz             # graph visualization
    grimblast            # screenshot program from hyprland
    gvfs                 # gnu Virtual Filesystem support library
    hexxy                # hexdump like xxd but nicer
    html-tidy            # html vlidator
    imv                  # image viewer
    ispell               # An interactive spell-checking program for Unix usec by emacs
    just                 # Like Make. Handy way to save and run project-specific commands
    killall              # kill processes by name
    lf                   # termina file manager in Go, like ranger
    librewolf            # privacy focused browser, fork of firefox
    libnotify            # notificationsk
    loupe                # image viewer
    lshw                 # get display info
    lsof                 # A tool to list open files
    nemo        # file explorer
    mimeo
    mp4v2                # Provides functions to read, create, and modify mp4 files
    # multipass            # Ubuntu VMs on demand for any worksation
    nerdfetch            # command-line system information
    nil                  # yet another language server for nix
    nixpkgs-fmt          # format nix files
    nix-prefetch-git
    nix-search-cli       # faster nix serach client
    nodejs_24
    pandoc               # Conversion between documents
    parted               # disk partion tool
    pa_applet            # pulseaudio applet for trayer
    pgformatter          # postgresql sql syntax beatifier
    prettyping           # like ping
    ranger               # terminal file explorer
    rtags                # C/C++ client-server indexer based on clang
    ripgrep              # fast grep
    sbcl                 # lisp compiler
    shfmt                # a shell parser and formatter
    signal-desktop
    slack                # messaging client
    speedtest-cli
    spotify              # music streaming service
    sqlite               # db sqlite
    solc                 # Compiler for Ethereum smart contract language Solidity
    stylelint            # CSS linter
    tmate                # tmux like Terminal Sharing
    tree                 # display files in a tree view
    vifm
    virt-manager         # mange vms
    virt-viewer          # view vmx
    virtiofsd
    volumeicon           # volume icon for trayer
    vscode               # ms visual studio
    watchexec            # execute commands in response to file change
    wayfarer             # Screen recording for wayland
    wezterm
    wl-clipboard         # clipboard support
    wofi                 # app launcher
    zip                  # zip archive
    unzip                  # zip archive
    zeal                 # offline api docs
    zoom-us
    emacsPackages.pdf-tools

  ] ++ fontPkgs ++ audioPkgs;

  haskellPkgs = [
    pkgs.haskellPackages.hoogle
  ];

  pythonPkgs = [
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.pandas
      python-pkgs.requests
      python-pkgs.isort

    ]))
  ];


  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  gblast = "${pkgs.grimblast}/bin/grimblast";
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  hyprpaper = "${pkgs.hyprpaper}/bin/hyprpaper";


  workspaceConf = { monitor }: ''
    workspace=1,persistent:true,monitor:${monitor}
    workspace=2,persistent:true,monitor:${monitor}
    workspace=3,persistent:true,monitor:${monitor}
    workspace=4,persistent:true,monitor:${monitor}
    workspace=5,persistent:true,monitor:${monitor}
    workspace=6,persistent:true,monitor:${monitor}
    workspace=7,persistent:true,monitor:${monitor}
    workspace=8,persistent:true,monitor:${monitor}
    workspace=9,persistent:true,monitor:${monitor}
  '';

in

{

  programs.home-manager.enable = true;

  imports =
    (import ./programs) ++
    (import ./services);

  xdg = {
    inherit configHome;
    enable = true;
  };

  home = {
    packages =
      defaultPkgs ++
      haskellPkgs ++
      pythonPkgs;

      sessionVariables = {
        DISPLAY = ":0";
        EDITOR = "vim";
        NIXOS_OZONE_WL = 1;
        MOZ_ENABLE_WAYLAND = "1";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        GDK_BACKEND = "wayland,x11";
        # QT_QPA_PLATFORM = "wayland;xcb";
      };
  };


  fonts.fontconfig.enable = true;

  # e.g. for slack, signal, etc
  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-termfilechooser
      ];
    };

    xdg.portal.config.common = {
      default = [ "hyprland" ];
      "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
    };
    xdg.portal.config.hyprland = {
      default = [ "hyprland" ];
      "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
    };

    home.sessionVariables.TERMCMD = "kitty --class=filechoose_yazi";

    xdg.configFile."xdg-desktop-portal-termfilechooser/config" = {
      force = true;
      text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      '';
    };

gtk = {
  enable = true;
  iconTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
  theme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
};



  # notifications about home-manager news
  news.display = "silent";

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };

  # Let Home Manager install and manage itself.
  # restart services on change
  systemd.user.startServices = "sd-switch";

  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacs30-gtk3;  # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
        epkgs.emacsql
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
  }; ## program


  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = (builtins.readFile ./wm/hyprland/hyprland.conf) + ''
      bind=SUPER,P,exec,"wofi" --show run --style=${./wm/hyprland/wofi.css} --term=footclient --prompt=Run
      bind=SUPER,A,exec,${gblast} save area
      bind=SUPER,S,exec,${gblast} save screen
      bind=SUPERCTRL,L,exec,${hyprlock}
      # audio volume bindings
      bindel=,XF86AudioRaiseVolume,exec,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel=,XF86AudioLowerVolume,exec,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindl=,XF86AudioMute,exec,${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindl=,Print,exec,${screenCapture}
      monitor = , preferred, auto, 1
      ${workspaceConf { monitor = ", preferred, auto, 1"; }}
      exec-once=${pkgs.blueman}/bin/blueman-applet
      exec-once=${pkgs.networkmanagerapplet}/bin/nm-applet --sm-disable --indicator
    '';

    plugins = [ ];

    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
    # xwayland.enable = true;
  };
}

