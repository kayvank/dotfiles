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
    boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];
    boot.kernelModules = [ "kvm-intel" "kvm-amd"];
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.extraModprobeConfig = "options kvm_intel nested=1";

    networking = {
      hostName = "saturn-xeon"; # Define your hostname.
      networkmanager.enable=true;
      useDHCP = false; # The global useDHCP flag is deprecated, therefore explicitly set to false here.
      firewall.enable = false;
      extraHosts =
        ''
          127.0.0.1 redis aws gcs googl postgres dynamodb
        '';
        # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    };

    # Set your time zone.
    time.timeZone = "America/Los_Angeles";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    #   console = { font = "latarcyrheb-sun32";  ##"Lat2-Terminus16"; keyMap = "us"; };

    fonts.fonts = with pkgs; [
      customFonts
      font-awesome
      nerdfonts
    ];

    services = {
      # Enable the X11 windowing system.
      xserver = {
        enable = true;
        # videoDrivers = [ "intel" ];
        displayManager = {
          lightdm.enable = true;        ## login manager
          defaultSession = "none+xmonad";
        };
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
        libinput = {
          enable = true;
          touchpad = {
            disableWhileTyping = true;
            tapping = true;
            buttonMapping = "lmr";
          };
        };
      };
      gnome.gnome-keyring.enable = true;
      upower.enable = true;
      dbus = {
        enable = true;
        packages = [ pkgs.dconf ];
      };
      openssh.enable = true;                         ## open ssh
      avahi = {
        enable = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };
      printing = {
        enable = true;
        drivers = [pkgs.mfcj6510dwlpr];              ## printer driver
        browsing = true;
        listenAddresses = [ "*:631" ];
        allowFrom = [ "all" ];
        defaultShared = true;
      };
    };

    sound.enable = true;
    # Enable sound.

    hardware = {
      pulseaudio = {
        enable = true;
        extraModules = [ pkgs.pulseaudio-modules-bt ];
        package = pkgs.pulseaudioFull;
      };
      bluetooth.enable = true;
    };


    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.kayvan = {
      initialPassword = "123XXX"; ## change password post login
      isNormalUser = true;
      extraGroups = [
        "qemu-libvirtd"
        "libvirtd"
        "docker"
        "networkmanager"
        "wheel"
        "scanner"
        "lp" ]; # wheel for ‘sudo’.
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
      qemu_kvm
    ];


    # Nix daemon config
    nix = {

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
      settings = {
        trusted-users = [ "root" "kayvan" ];
        auto-optimise-store = true;
      };
    };

    # started in user sessions.
    # programs.mtr.enable = true;
    programs = {
      # zsh.enable = true;
      dconf.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

    };

    # Enable Docker
    virtualisation = {
      docker = {
        enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };
    libvirtd.enable = true;

    };

    # kvm Virt-manager
    ## add google dns
    networking.networkmanager.insertNameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
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

