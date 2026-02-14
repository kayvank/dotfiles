{ config, lib, pkgs, ... }:

let
  zshConfig = ''
    bindkey -v
    eval "$(direnv hook zsh)"
    nerdfetch
    '';
in
{

  programs.zsh = {
    enable = true;


    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = ["main" "brackets" "pattern" "regexp" "root" "line"];
    };
    historySubstringSearch.enable = true;

    history = {
      ignoreDups = true;
      save = 10000;
      size = 10000;
    };



    dotDir = "${config.xdg.configHome}/zsh";
    shellAliases = {
      # cat     = "bat";
      config    = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      dc        = "docker-compose";
      dps       = "docker-compose ps";
      dcd       = "docker-compose down --remove-orphans";
      emc       = "nohup emacsclient -c &> /desv/null &";
      emd       = "emacs --daemon";
      ping      = "prettyping";
      pbcopy    = "wl-copy";
      pbpaste   = "wl-paste";
      wiohk     = "cd ~/dev/workspaces/iohk";
      wq2io     = "cd ~/dev/workspaces/q2io";
      wdev      = "cd ~/dev";
      wwork     = "cd ~/dev/workspaces";
      tmx       = "tmux new-session -s $USER-`date +%s`";
      kssh      = "kitten ssh";
      xxd       = "hexxy";
      firefox-iohk = "hyprctl -q dispatch exec firefox -- -P 'iohk'";
      firefox-q2io = "hyprctl -q dispatch exec firefox -- -P 'q2io'";
      firefox-kayvan = "hyprctl -q dispatch exec firefox -- -P 'kayvan'";
      firefox-schwarzer-swan = "hyprctl -q dispatch exec firefox -- -P 'schwarzer-swan'";
      # firefox-iohk = "nohup firefox -P 'iohk' 2>&1 > /dev/null &";
      # firefox-q2io = "nohup firefox -P 'q2io'  2>&1 > /dev/null &";
      # firefox-kayvan = "nohup firefox -P 'kayvan' 2>&1 > /dev/null &";
      # firefox-schwarzer-swan = "nonup firefox -P 'schwarzer-swan' 2>&1 > /dev/null &";
    };
    sessionVariables = { ## shell env vars are set here
      "EDITOR" = "vim";
      "VISUAL" = "vim";
      "HISTFILESIZE" = "1000000000"; # Bigger history files for all users
      "HISTSIZE" = "1000000000";
      "HISTTIMEFORMAT"="[%F %T] ";
      # "PATH" = "$PATH:/home/kayvan/bin:/home/kayvan/.local/share/npm_global/bin";
      DIRENV_ALLOW_NIX=1;
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell" ; ## lambda
    };

    # initExtra   = zshConfig;
    initContent   = zshConfig;
  };
}
