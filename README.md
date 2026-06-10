# macOS Nix Packages and Stow Dotfiles

This repo uses Nix only for installing packages. Dotfiles are regular files
managed with GNU Stow.

Install or update the package bundle:

```sh
nix-env -f "$HOME/.config/nix/package.nix" -ir
```

Preview the package switch:

```sh
nix-env -f "$HOME/.config/nix/package.nix" -ir --dry-run
```

Start with a simple channel-based `package.nix`:

```nix
let
  pkgs = import <nixpkgs> { };
in

pkgs.buildEnv {
  name = "altaria-user-packages";
  paths = with pkgs; [
    stow
    helix
    git
    ripgrep
  ];
}
```

Then pin `nixpkgs` with `npins`:

```sh
npins init --bare
npins add github NixOS nixpkgs --branch nixpkgs-unstable
```

The final `package.nix` imports `nixpkgs` from `./npins` instead of from
`<nixpkgs>`. Update the pin with:

```sh
npins update nixpkgs
```

Link dotfiles into `$HOME`:

```sh
cd ~/.config/nix
stow -d dotfiles -t ~ zsh starship direnv tealdeer helix zellij fish ghostty
```

Preview Stow changes first:

```sh
stow -n -v -d dotfiles -t ~ zsh starship direnv tealdeer helix zellij fish ghostty
```

Unlink a package:

```sh
stow -D -d dotfiles -t ~ helix
```
