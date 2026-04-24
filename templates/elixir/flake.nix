{
  description = "Elixir / Phoenix dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        beam = pkgs.beam.packages.erlang_27;
        elixir = beam.elixir_1_18;
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            beam.erlang
            elixir
            pkgs.nodejs_22
            pkgs.pnpm
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
          '';
        };
      });
}
