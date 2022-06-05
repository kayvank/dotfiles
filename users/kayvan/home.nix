{ config, pkgs, lib, stdenv, ... }:
let
  defaultPkgs = with pkgs; [
    awscli2                  # AWS cli
    aws-mfa              # Manage AWS MFA Security Credentials
    docker-compose       # docker manager
    direnv               # customize env per directory
    exa                  # a better `ls`
    fd                   # "find" for files
    google-cloud-sdk
    ispell               # An interactive spell-checking program for Unix usec by emacs
    killall              # kill processes by name
    libnotify            # notify-send command
    neofetch             # command-line system information
    postgresql
    python39Full
    ripgrep              # fast grep
    rnix-lsp             # nix lsp server
    sqlite
    terraform            # terraform
    tree                 # display files in a tree view
    # virt-manager
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
       defaultPkgs 
       ++ gitPkgs 
       ## ++ haskellPkgs 
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


  # restart services on change
  systemd.user.startServices = "sd-switch";

  # notifications about home-manager news

  programs = {
    zsh = { enable = true; };
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
            HostName XXX.XXX.XXX.XXX
            User soostone
        Host devkayvan
            HostName XXX.XXX.XXX.XXX
            User kayvan
        Host soostone
            HostName 192.168.183.166
            User kayvan
      '';
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [];
    };


  };
}
