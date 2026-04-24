{
  description = "Haskell dev shell (GHC + Cabal + HLS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        hpkgs = pkgs.haskellPackages;
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            hpkgs.ghc
            hpkgs.cabal-install
            hpkgs.haskell-language-server
            hpkgs.hlint
            hpkgs.ormolu
            hpkgs.ghcid
            pkgs.zlib
            pkgs.git
          ];

          shellHook = ''
            export CABAL_DIR="$PWD/.nix/cabal"
            export PATH="$CABAL_DIR/bin:$PATH"
          '';
        };
      });
}
