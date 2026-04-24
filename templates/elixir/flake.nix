{
  description = "Elixir / Phoenix dev shell";

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
          beam = pkgs.beam.packages.erlang_27;
          elixir = beam.elixir_1_18;

          # Dexter LSP — prebuilt binaries from github.com/remoteoss/dexter
          dexterVersion = "0.6.0";
          dexterAssets = {
            "aarch64-darwin" = { asset = "dexter_Darwin_arm64.tar.gz";  sha256 = "b3bdf0fc783e059abf7670b1162c7c9fdcc815cbeaab2899781272b6ee4585f6"; };
            "aarch64-linux"  = { asset = "dexter_Linux_arm64.tar.gz";   sha256 = "c387f4dc14c4d6cf9c9fbd91c2ef16e0f2530c54617900635b11a4e1fe3cf2ae"; };
            "x86_64-linux"   = { asset = "dexter_Linux_x86_64.tar.gz";  sha256 = "78582a890739937332decd00c0b8553512f1ad526f3c414fd6d654aaebb8a2e6"; };
          };
          dexterAsset = dexterAssets.${system} or null;
          dexter = if dexterAsset == null then null else
            pkgs.stdenv.mkDerivation {
              pname = "dexter";
              version = dexterVersion;
              src = pkgs.fetchurl {
                url = "https://github.com/remoteoss/dexter/releases/download/v${dexterVersion}/${dexterAsset.asset}";
                sha256 = dexterAsset.sha256;
              };
              sourceRoot = ".";
              dontBuild = true;
              nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.autoPatchelfHook ];
              buildInputs = [ pkgs.sqlite ];
              installPhase = ''
                mkdir -p $out/bin
                install -m755 dexter_*/dexter $out/bin/dexter
              '';
              meta.mainProgram = "dexter";
            };
        in {
          default = pkgs.mkShell {
            packages = [
              beam.erlang
              elixir
              pkgs.nodejs_22
              pkgs.pnpm
              pkgs.sqlite
              pkgs.git
            ] ++ pkgs.lib.optional (dexter != null) dexter
              ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
                pkgs.inotify-tools
                pkgs.libnotify
              ];

            shellHook = ''
              # Project-local mix/hex caches so flakes don't fight over $HOME.
              export MIX_HOME="$PWD/.nix/mix"
              export HEX_HOME="$PWD/.nix/hex"
              export PATH="$MIX_HOME/escripts:$PATH"
              export ERL_AFLAGS="-kernel shell_history enabled"
              export LANG="en_US.UTF-8"

              # Preinstall hex/rebar so `mix deps.get` doesn't block on an
              # interactive prompt in fresh shells.
              mix local.hex --force --if-missing >/dev/null
              mix local.rebar --force --if-missing >/dev/null
            '';
          };
        });
    };
}
