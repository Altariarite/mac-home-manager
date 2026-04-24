{ ... }:

{
  # Auto-start zellij in new zsh sessions. Skips if already inside zellij.
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  # Zsh with fish-like UX: autosuggestions, syntax highlighting, history search.
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autosuggestion.highlight = "fg=#999999";
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      jj-sync = "jj git fetch && jj rebase -d main";
      ze = "zellij";
    };
    # Keep brew available alongside nix (casks, anything not migrated).
    initContent = ''
      if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    '';
  };

  # Prompt with built-in jj/git detection. Configure via ~/.config/starship.toml
  # or programs.starship.settings here.
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$directory$custom$nix_shell\n$character";

      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
        fish_style_pwd_dir_length = 0;
        style = "bold cyan";
      };

      nix_shell = {
        format = "via [$symbol$state]($style) ";
        symbol = "nix ";
        style = "bold blue";
      };

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };

      # jj/git prompt via jj-starship. --id-length 4 for short change_id.
      # Ancestor bookmarks (default depth 10) render as e.g. `main~3`.
      custom.jj = {
        command = "jj-starship prompt --id-length 4 --jj-symbol='󱗆 ' --bookmarks-display-limit 1 --no-git-prefix";
        when = "jj-starship detect";
        format = "[$output]($style) ";
        style = "bold purple";
      };
    };
  };

  # Ctrl-R fuzzy history, Ctrl-T fuzzy file picker.
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Smarter `cd` — type `z foo` to jump to a frequent directory.
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Map ~/.config/<tool>/... → dotfiles/<tool>/... in this repo.
  xdg.configFile = {
    "ghostty/config".source = ./dotfiles/ghostty/config;
    "helix/config.toml".source = ./dotfiles/helix/config.toml;
    "helix/languages.toml".source = ./dotfiles/helix/languages.toml;
    "zellij/config.kdl".source = ./dotfiles/zellij/config.kdl;
    "zellij/layouts" = {
      source = ./dotfiles/zellij/layouts;
      recursive = true;
    };
  };
}
