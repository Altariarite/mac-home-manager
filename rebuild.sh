#!/bin/sh

nix-env -f "$HOME/.config/nix/package.nix" -ir
stow --restow --dir "$HOME/.config/nix/dotfiles" --target "$HOME" direnv fish ghostty helix starship tealdeer zellij zsh
