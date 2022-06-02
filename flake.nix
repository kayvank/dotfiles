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
    homeManagerConfig = {
      kayvan = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "kayvan";
        homeDirectory = "/home/kayvan";
        configuration = import ./users/kayvan/home.nix ;
      };
    };
    nixosConfigurations = {
      dev-saturn = lib.nixosSystem { ## gets all the system stuff by hostname
      inherit system;

      modules = [
        ./system/configuration.nix
      ];
      };
    };
  };
}
