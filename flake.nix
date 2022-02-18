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
      soostone = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "soostone";
        homeDirectory = "/home/soostone";
        configuration = import ./users/soostone/home.nix ;
      };
    };
    nixosConfigurations = {
      soostone-dev = lib.nixosSystem { ## gets all the system stuff by hostname, soostone-dev
      inherit system;

      modules = [
        ./system/configuration.nix
      ];
      };
    };
  };
}
