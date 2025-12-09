{
  description = "Kayvan System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url ="github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; ## use our nixpkgs instead of HM one
    };
    iohk-hix = {
      url = "github:input-output-hk/haskell.nix";
    };
        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        firefox-addons = {
          url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
        };
        swww.url = "github:LGFae/swww";
  };

  outputs =
  { self
  , nixpkgs
  # , nurpkgs , text2nix
  , home-manager
  , iohk-hix
  , hyprland
  , hyprland-plugins
  , nur
  , firefox-addons
  , swww
  , ... } @ inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
      overlays = [nur.overlay];
    };
    lib = nixpkgs.lib;


  in {
    homeManagerConfigurations = {
      kayvan = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./users/kayvan/home.nix
          {
            home = {
              username = "kayvan";
              homeDirectory = "/home/kayvan";
              stateVersion = "25.05";
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      saturn-iohk = lib.nixosSystem { ## gets all the system stuff by hostname
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ./system/configuration.nix
      ];
      };
    };
  };
}
