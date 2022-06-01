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
    ./cache.nix
    ];

    nixpkgs.config.allowUnfree = true;

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "soostone-laptop"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable=true;

    # Set your time zone.
    time.timeZone = "America/Los_Angeles";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.extraHosts =
      ''
        127.0.0.1 redis aws gcs googl postgres dynamodb
      '';

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

      # List services that you want to enable:
      services = {

        # Enable the X11 windowing system.
        xserver = {
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
          displayManager.lightdm.enable = true;        ## login manager
          windowManager.xmonad.enable = true;          ## window manager
        };
        openssh.enable = true;                         ## open ssh
        printing = {
          enable = true;
          drivers = [pkgs.mfcj6510dwlpr];              ## printer driver
        };
      };

      sound.enable = true;                            ## Enable sound.
      hardware.pulseaudio.enable = true;
      hardware.bluetooth.enable = true;
      programs.zsh.enable = true;
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.soostone = {
        initialPassword = "123XXX"; ## change password post login
        isNormalUser = true;
        extraGroups = ["libvirtd" "docker" "networkmanager" "wheel" "scanner" "lp" ]; # wheel for ‘sudo’.
        shell = pkgs.zsh;
      };

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        vim
        wget
        brave
        konsole
        home-manager
        pciutils
        xorg.xbacklight
      ];

      # Nix daemon config
      nix = {
        settings.auto-optimise-store = true;        # Automate `nix-store --optimise`
        gc = {  # Automate garbage collection
          automatic = true;
          dates     = "weekly";
          options   = "--delete-older-than 7d";
        };
        extraOptions = ''
          experimental-features = nix-command flakes
          keep-outputs          = true
          keep-derivations      = true
          allow-import-from-derivation = true
        '';

        # Required by Cachix to be used as non-root user
        settings.trusted-users = [ "root" "soostone" ];
      };


      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      virtualisation = {      # Enable Docker
        docker = {
          enable = true;
          autoPrune = {
            enable = true;
            dates = "weekly";
          };
        };
      };

      virtualisation.libvirtd.enable = true;      # kvm Virt-manager
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

