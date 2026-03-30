{ config, lib, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      macos_option_as_alt = "left"; ## fix the `Alt` and `Ctrl` key in terminal mode with emacs orgmode
      font_family = "Mono Book";
      font_size = 13;
      enable_audio_bell = false;
    };
    shellIntegration.enableZshIntegration = true;

  };
}
