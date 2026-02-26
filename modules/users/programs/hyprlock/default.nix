{ pkgs, config, ... }:  {

  imports =
    [
      ../../scripts/battery.nix
    ];

  xdg.configFile."hypr/hyprlock.conf".text = ''

   $background = rgb(171717)
    $foreground = rgb(F9F9F9)
    $color0 = rgb(3E3E3E)
    $color1 = rgb(181818)
    $color2 = rgb(454545)
    $color3 = rgb(505050)
    $color4 = rgb(6C6C6C)
    $color5 = rgb(797979)
    $color6 = rgb(B2B2B2)
    $color7 = rgb(EEEEEE)
   $color8 = rgb(A6A6A6)
   $color9 = rgb(202020)
   $color10 = rgb(5C5C5C)
   $color11 = rgb(6A6A6A)
   $color12 = rgb(909090)
   $color13 = rgb(A1A1A1)
   $color14 = rgb(EDEDED)
   $color15 = rgb(EEEEEE)
general {
    grace = 1
    fractional_scaling = 2
    immediate_render = true
}

background {
    monitor =
    # NOTE: use only 1 path
   path = $HOME/.config/dotfiles/wallpapers/alien-blue.jpg  # current wallpaper

    color = rgb(0,0,0) # color will be rendered initially until path is available

    # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
    blur_size = 3
    blur_passes = 2 # 0 disables blurring
    noise = 0.0117
    contrast = 1.3000 # Vibrant!!!
    brightness = 0.8000
    vibrancy = 0.2100
    vibrancy_darkness = 0.0
}


# Date
label {
    monitor =
    text = cmd[update:18000000] echo "<b> "$(date +'%A, %-d %B')" </b>"
    color = $color13
    font_size = 64
    # font_family = Victor Mono Bold Italic
    font_family = JetBrainsMono
    position = 0, -20
    halign = center
    valign = center
}

# Hour-Time (single horizontal time like 1080p variant)
label {
    monitor =
#     text = cmd[update:1000] echo "$(date +"%H:%M")"   # 24h option
    text = cmd[update:1000] echo "$(date +"%I:%M %p")" # AM/PM
	#color = rgba(255, 185, 0, .8)
    color = $color8
    font_size = 173
    font_family = JetBrainsMono ExtraBold
    position = 0, -133
    halign = center
    valign = top
}

# USER
label {
    monitor =
    text =   $USER
    color = $color9
    font_size = 48
    # font_family = Victor Mono Bold Oblique
    font_family = JetBrainsMono
    position = 0, 300
    halign = center
    valign = bottom
}

# INPUT FIELD
input-field {
    monitor =
    size = 306, 93
    outline_thickness = 2
    dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 0.2 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = true
    outer_color = $color8
    inner_color = rgba(255, 255, 255, 0.1)
	capslock_color = rgb(255,255,255)
    font_color = $color13
    fade_on_empty = false
    # font_family = Victor Mono Bold Oblique
    font_family = JetBrainsMono
    placeholder_text = <i><span foreground="##ffffff99">🔒 Type Password</span></i>
    hide_input = false
    position = 0, 100
    halign = center
    valign = bottom
}

# Keyboard LAYOUT
label {
    monitor =
    text = $LAYOUT
    color = $color8
    font_size = 19
    # font_family = Victor Mono Bold Oblique
    font_family = JetBrainsMono
    position = 0, 53
    halign = center
    valign = bottom
}

# uptime
label {
    monitor =
    text = cmd[update:60000] echo "<b> "$(uptime -p || ~/.config/scripts/UptimeNixOS.sh)" </b>"
    color = $color9
    font_size = 21
    # font_family = Victor Mono Bold Oblique
    font_family = JetBrainsMono
    position = 0, 0
    halign = right
    valign = bottom
}

# battery information
label {
    monitor =
    text = cmd[update:1000] echo "<b> "$(${config.scripts.battery}/bin/${config.scripts.battery.name})" </b>"
    color = $color9
    font_size = 21
    # font_family = Victor Mono Bold Oblique
    font_family = JetBrainsMono
    position = 0, 45
    halign = right
    valign = bottom
}
# weather edit the scripts for locations
# weather report is created by weather-report service in ~/.config/dotfiles/modules/users/services/weather-report/
label {
    monitor =
    text = cmd[update:3600000] [ -f "$HOME/.cache/.weather_cache" ] && cat  "$HOME/.cache/.weather_cache"
    color = $color8
    font_size = 19
    # font_family = Victor Mono Bold Oblique
    font_family = JetBrainsMono
    position = 50, 0
    halign = left
    valign = bottom
}


  '';
}
