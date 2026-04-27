{
  description = "Common Lisp dev shell (SBCL + Quicklisp + rlwrap)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems f;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.sbcl
              pkgs.rlwrap
              pkgs.git
            ];

            shellHook = ''
              echo "SBCL ready. For a readline REPL: rlwrap sbcl"
              echo "Helix LSP (alive-lsp) is wired globally via home-manager."
            '';
          };
        }
      );
    };
}
