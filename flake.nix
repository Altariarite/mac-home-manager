{
  description = "Home Manager configuration + project flake templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."altaria" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };

      templates = {
        elixir = {
          path = ./templates/elixir;
          description = "Elixir + Phoenix dev shell (OTP 27, Node, pnpm)";
        };
        haskell = {
          path = ./templates/haskell;
          description = "Haskell dev shell (GHC + Cabal + HLS + tooling)";
        };
      };
    };
}
