{
  description = "Kayvan System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; ## use our nixpkgs instead of HM one
    };
    iohk-hix = {
      url = "github:input-output-hk/haskell.nix";
    };
    # nurpkgs = {url = github:nix-community/NUR; inputs.nixpkgs.follows = "nixpkgs";};
    # text2nix = {url = github:Mic92/tex2nix/4b17bc0; inputs.utils.follows = "nixpkgs";};
  };

  outputs = inputs @
    { self
    , nixpkgs
    # , nurpkgs , text2nix
    , home-manager
    , iohk-hix
    , ... }:
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
      saturn-iohk = lib.nixosSystem { ## gets all the system stuff by hostname
      inherit system;

      modules = [
        ./system/configuration.nix
      ];
      };
    };
  };


}
