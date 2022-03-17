# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

let
  customFonts = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "Iosevka"
    ];
  };
  ## Make ready for nix flakes
  ##
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

in
{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./nvidia.nix
    ./wm/xmonad.nix
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "saturn-xeon"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable=true;

    # Set your time zone.
    time.timeZone = "America/Los_Angeles";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    # networking.useDHCP = false;
    # networking.interfaces.wlp59s0.useDHCP = true;
    ##networking.interfaces.enp58s0u1.useDHCP = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    #   console = { font = "latarcyrheb-sun32";  ##"Lat2-Terminus16"; keyMap = "us"; };

    fonts.fonts = with pkgs; [
      customFonts
      font-awesome
    ];

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      xrandrHeads = [
        { output = "HDMI-1";
        primary = true;
        monitorConfig = ''
          Option "PreferredMode"  "3840x2160"
          Option "Position" "0 0"
        '';
        }
        { output = "eDP-1";
        monitorConfig = ''
          Option "PreferredMode" "2560x1440"
          Option "Position" "0 0"
        '';
        }
      ];
      resolutions = [
        { x = 2048; y = 1152; }
        { x = 1920; y = 1080; }
        { x = 2560; y = 1440; }
        { x = 3072; y = 1728; }
        { x = 3840; y = 2160; }
      ];


      videoDrivers = [ "intel" ];
      # dpi = 180;
      # libinput.enable = true;
      displayManager = {
        lightdm.enable = true;
        # sddm.enable = true;
        # plasma5.enable = true;
        #startx.enable = true;
      };
      windowManager.xmonad.enable = true;
    };


    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.bluetooth.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    programs.zsh.enable = true;
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.kayvan = {
      initialPassword = "123XXX"; ## change password post login
      isNormalUser = true;
      extraGroups = [ "docker" "networkmanager" "wheel" "scanner" "lp" ]; # wheel for ‘sudo’.
      shell = pkgs.zsh;
    };


    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      git
      wget
      firefox
      konsole
      home-manager
      pciutils
      xorg.xbacklight
    ];


    # Nix daemon config
    nix = {
      # Automate `nix-store --optimise`
      settings.auto-optimise-store = true;

      # Automate garbage collection
      gc = {
        automatic = true;
        dates     = "weekly";
        options   = "--delete-older-than 7d";
      };

      ##
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs          = true
        keep-derivations      = true
      '';

      # Required by Cachix to be used as non-root user
      settings.trusted-users = [ "root" "kayvan" ];
    };


    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Enable Docker
    virtualisation = {
      docker = {
        enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };
    };

    # kvm Virt-manager
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.05"; # Did you read the comment?

}

