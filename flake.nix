{
  description = "My Awesome System Config of Doom";

  ## all the required external stuff
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; ## use our nixpkgs instead of HM one
    };
    nurpkgs = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    text2nix = {
      url = github:Mic92/tex2nix/4b17bc0;
      inputs.utils.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = inputs @ {self, nixpkgs, nurpkgs, home-manager, text2nix,  nix-doom-emacs, ... }:
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
        inherit system pkgs;
        username = "kayvan";
        homeDirectory = "/home/kayvan";
        configuration = import ./users/kayvan/home.nix ;
      };
    };
    nixosConfigurations = {
      saturn-xeon = lib.nixosSystem { ## gets all the system stuff by hostname, saturn-xeon
      inherit system;

      modules = [
        ./system/configuration.nix
      ];
      };
    };
  };
}
