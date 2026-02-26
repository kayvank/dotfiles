{ lib, pkgs, config, ... }: {

  options = {
    scripts = {
      battery = lib.mkOption {
        type = lib.types.package;
      };
    };
  };

  config =  {
    scripts.battery = pkgs.writeShellApplication {
      name = "battery";
      runtimeInputs = [];
      text = '' ${./UserScripts/Battery.sh} '';
    };
  };

}
