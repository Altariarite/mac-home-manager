{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "altaria";
  home.homeDirectory = "/Users/altaria";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  programs.helix.enable = true;

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

      # jj: show change/bookmark via custom command
      custom.jj = {
        command = ''
          jj log -r@ -T 'separate(" ", change_id.shortest(4), bookmarks)' --no-graph 2>/dev/null
        '';
        when = "jj root 2>/dev/null";
        symbol = "jj ";
        style = "bold purple";
        format = "[$symbol($output)]($style) ";
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
    # "fish/config.fish".source = ./dotfiles/fish/config.fish;
    # "fish/functions/fish_jj_prompt.fish".source = ./dotfiles/fish/functions/fish_jj_prompt.fish;
    # "fish/functions/jj-sync.fish".source = ./dotfiles/fish/functions/jj-sync.fish;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Keep fish available as an alternate shell; configs are symlinked above.
    fish

    # Version control
    jujutsu # `jj`
    jjui
    git
    gh
    delta # git-delta

    # CLI utilities
    fd
    ripgrep
    coreutils
    wget
    tree-sitter

    # Global language support
    nixfmt
    taplo # toml

    # AI
    claude-code

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
