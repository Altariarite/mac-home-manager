{
  description = "Home Manager configuration + project flake templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    basecamp-cli.url = "github:basecamp/basecamp-cli";
    basecamp-cli.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, home-manager, basecamp-cli, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."altaria" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          basecamp-cli = basecamp-cli.packages.${system}.default;
        };
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
        common-lisp = {
          path = ./templates/common-lisp;
          description = "Common Lisp dev shell (SBCL + Quicklisp + rlwrap)";
        };
      };
    };
}
