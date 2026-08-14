let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
in

with pkgs; [
    # Dotfile management
    stow
    npins

    # Nix command documentation
    nix.man

    # Shells and shell integrations
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    fish
    starship
    fzf
    zoxide
    direnv
    nix-direnv

    # Terminal/editor tools
    helix
    zellij
    tealdeer

    # Version control
    jujutsu
    jjui
    jj-starship
    git
    gh
    delta

    # CLI utilities
    fd
    ripgrep
    coreutils
    wget
    tree-sitter
    glow
    uv
    ffmpeg
    zola

    # macOS applications
    xld

    # Global language support
    nixfmt
    nil
    taplo
    ruby_4_0
    julia
    sbcl
    rlwrap
    clojure
    clojure-lsp
    clj-kondo
    babashka

    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.geist-mono
    nerd-fonts.hack
    nerd-fonts.commit-mono

    # AI
    codex
    opencode
]
