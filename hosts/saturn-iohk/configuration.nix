{ ... }:

{
  config = {
    systemSettings = {
      # users
      users = [ "kayvan" ];
      adminUsers = [ "kayvan" ];

      # hardware
      cachy.enable = true;
      bluetooth.enable = true;
      powerprofiles.enable = true;
      tlp.enable = false;
      printing.enable = true;

      # software
      flatpak.enable = false;
      gaming.enable = false;
      virtualization = {
        docker.enable = true;
        virtualMachines.enable = true;
        libvirtd = {
          enable = true;
          qemu = {
            swtpm.enable = true;
          };
        };
      brave.enable = true;
      firefox.enable = true;

      # wm
      hyprland.enable = true;

      # dotfiles
      dotfilesDir = "/etc/nixos";

      # security
      security = {
        automount.enable = true;
        blocklist.enable = true;
        doas.enable = true;
        firejail.enable = false; # TODO setup firejail profiles
        firewall.enable = true;
        gpg.enable = true;
        openvpn.enable = true;
        sshd.enable = false;
      };

      # style
      stylix = {
        enable = true;
        theme = "orichalcum";
      };
    };

    users.users.kayvan.description = "Kayvan";
    home-manager.users.USERNAME.userSettings = {
      name = "Kayvan";
      email = "kayvan@q2io.com";
    };

    ## EXTRA CONFIG GOES HERE

  };

}
