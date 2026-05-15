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
        in {
          default = pkgs.mkShell {
            packages = [
              beam.erlang
              elixir
              beam.expert
              pkgs.nodejs_22
              pkgs.pnpm
              pkgs.sqlite
              pkgs.git
            ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
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
