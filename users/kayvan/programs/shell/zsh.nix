{ config, lib, pkgs, ... }:

let
  zshConfig = ''
    bindkey -v
    eval "$(direnv hook zsh)"
    # neofetch
    '';
in
{

  programs.zsh = {
    shellAliases = {
      # cat     = "bat";
      config    = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      dc        = "docker-compose";
      dps       = "docker-compose ps";
      dcd       = "docker-compose down --remove-orphans";
      emc       = "nohup emacsclient -c &> /dev/null &";
      emd       = "emacs --daemon";
      ping      = "prettyping";
      pbcopy    = "xsel -ib";
      pbpaste   = "xsel -ob";
      whaskell  = "cd ~/dev/workspaces/workspace-haskell";
      wsoos     = "cd ~/dev/workspaces/workspace-soostone";
      wproto    = "cd ~/dev/workspaces/workspace-proto";
      wnixos    = "cd ~/dev/workspaces/workspace-nixos";
      tmx       = "tmux new-session -s $USER-`date +%s`";
    };
    sessionVariables = { ## shell env vars are set here
      "EDITOR" = "vim";
      "VISUAL" = "vim";
      "HISTFILESIZE" = "1000000000"; # Bigger history files for all users
      "HISTSIZE" = "1000000000";
      "HISTTIMEFORMAT"="[%F %T] ";
      DIRENV_ALLOW_NIX=1;
    };
    oh-my-zsh = {
      enable = true;
      theme = "lambda" ; ##robbyrussell";
    };

    initExtra   = zshConfig;
  };
}
