{
  description = "My Awesome System Config of Doom";

  ## all the required external stuff
  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; ## use our nixpkgs instead of HM one
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      kayvan = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./users/kayvan/home.nix
          {
            home = {
              username = "kayvan";
              homeDirectory = "/home/kayvan";
              stateVersion = "22.05";
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      saturnt480s = lib.nixosSystem { ## gets all the system stuff by hostname, saturn480s
      inherit system;
      modules = [./system/configuration.nix];
      };
    };
  };
}
