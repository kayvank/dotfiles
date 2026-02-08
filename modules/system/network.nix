{ config, lib, pkgs, ... }:

{
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "saturn-iohk";
  networking.extraHosts =
    ''
    192.168.122.156 saturn-vm
    '';
  # Pick only one of the below networking options.
  networking.networkmanager = {
    enable = true; # Easiest to use and most distros use this by default.
    insertNameservers = [ # # google nameservers
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  # Open ports in the firewall.
   networking.firewall = {
   enable = true;
   allowedTCPPorts = [ 8666 443 ];
   allowedUDPPortRanges = [
     { from = 44440; to = 44449; }
     { from = 33330; to = 33339; }
   ];
 };
}
