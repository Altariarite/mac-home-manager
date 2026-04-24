{
  description = "Haskell dev shell (GHC + Cabal + HLS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems f;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          hpkgs = pkgs.haskellPackages;
        in {
          default = pkgs.mkShell {
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
    };
}
