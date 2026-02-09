{
  description = "Kayvan System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
    chaotic.url = "github:chaotic-cx/nyx";
    hyprlock = {
      url = "github:hyprwm/hyprlock/v0.9.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:nix-community/stylix";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    hyprland.url ="github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; ## use our nixpkgs instead of HM one
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

  outputs = inputs@{ self, ...}:

  let
    host = "saturn-iohk";
    username = "kayvan";
    useremail = "kayvan@q2io.com";
    profile = "nvidia-laptop";

    system = "x86_64-linux";

      # create patched nixpkgs
      nixpkgs-patched = (import inputs.nixpkgs { inherit system; }).applyPatches {
        name = "nixpkgs-patched";
        src = inputs.nixpkgs;
        patches = [
          #(builtins.fetchurl {
          #  url = "https://asdf1234.patch";
          #  sha256 = "sha256:qwerty123456...";
          #})
        ];
      };

      # configure pkgs
      # use nixpkgs if running a server (homelab or worklab profile)
      # otherwise use patched nixos-unstable nixpkgs
      pkgs = import nixpkgs-patched {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = [
          inputs.rust-overlay.overlays.default
          inputs.emacs-overlay.overlays.default
          inputs.chaotic.overlays.default
        ];
      };

      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      # configure lib
      lib = inputs.nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      kayvan = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        inherit inputs;
        inherit host;
        inherit username;
        inherit useremail;
        inherit profile;
      };
       # extraSpecialArgs = { inherit inputs; };
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          ./modules/users
          {
            home = {
              username = "kayvan";
              homeDirectory = "/home/kayvan";
              stateVersion = "26.05";
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      saturn-iohk = lib.nixosSystem { ## gets all the system stuff by hostname
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit host;
        inherit username;
        inherit useremail;
        inherit profile;
      };
      modules = [
        inputs.stylix.nixosModules.stylix
        ./modules/system/configuration.nix
      ];
      };
    };
  };
}
