{ config, lib, pkgs, ... }:

{
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.kernelModules = [ ];
    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "sd_mod"
    ];
    # boot.kernelParams = [ "module_blacklist=hid_sensor_hub" ];
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelModules = [ "kvm-intel" "btqca" "hci_qca" "hci_uart" "sg" "btintel" ];
    boot.extraModulePackages = [ ];

    boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];
    boot.loader.systemd-boot.configurationLimit = 5;
}
