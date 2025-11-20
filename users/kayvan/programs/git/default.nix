{ config, pkgs, ... }:
let

  rg = "${pkgs.ripgrep}/bin/rg";
in {
  programs.git = {
    signing.key = "D2B4E616C9524F86";
    signing.signByDefault=true;
    settings = {
      user.email = "kayvan@q2io.com";
      user.name = "kayvank";
    };


    enable = true;
    lfs.enable = true;
    # extraConfig = gitConfig;
    includes = [
      {
        ##  include for all repositories inside workspace-iohk
        condition = "gitdir:$HOME/dev/workspaces/iohk/";
        path = "$HOME/.config/dotfiles/git-configs/iohk.inc";
      }

      {
        ##  include for all repositories inside workspace-q2io
        condition = "gitdir:$HOME/dev/worksapces/q2io/";
        path = "$HOME/.config/dotfiles/git-configs/q2io.inc";
      }
      {
        ##  include for all repositories inside workspace-schwarzer-swan
        condition = "gitdir:$HOME/dev/workspaces/schwarzer-swan/";
        path = "$HOME/.config/dotfiles/git-configs/schwarzer-swan.inc";
      }
      {
        condition = "gitdir:$HOME/.config/";
        path = "$HOME/.config/dotfiles/git-configs/q2io.inc";
      }
    ];

    };
}
