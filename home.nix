{
  config,
  pkgs,
  lib,
  basecamp-cli,
  ...
}:

{
  imports = [ ./shell.nix ];

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

  programs.helix = {
    enable = true;
    settings = {
      theme = "modus_operandi";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        true-color = true;
        rulers = [ 80 ];

        default-yank-register = "+";
        auto-format = true;
        end-of-line-diagnostics = "hint";
        auto-save = {
          focus-lost = true;
          after-delay = {
            enable = true;
            timeout = 2000;
          };
        };
        lsp = {
          display-messages = true;
          display-progress-messages = true;
          display-inlay-hints = false;
          auto-signature-help = true;
        };
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "disable";
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
      };

      keys.normal = {
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
        space.w = ":w";
        space.q = ":q";
        "$" = "goto_line_end";
        "0" = "goto_line_start";
      };
    };

    # Editor-infrastructure language servers/formatters that should be available
    # everywhere (even outside a project dev shell). Toolchain-coupled servers
    # (rust-analyzer, expert, ruby-lsp) live in their project's dev shell instead.
    extraPackages = with pkgs; [
      nil # nix
      nixfmt-rfc-style # nix formatter
    ];

    # auto-format is enabled globally via editor.auto-format above, so it's not
    # repeated per language here.
    languages = {
      language-server = {
        expert = { command = "expert"; };
        rust-analyzer.config.check.command = "clippy";
      };

      language = [
        {
          name = "nix";
          formatter = { command = "nixfmt"; args = [ "-" ]; };
        }
        {
          name = "rust";
          formatter = { command = "rustfmt"; };
        }
        {
          name = "elixir";
          language-servers = [ "expert" ];
          formatter = { command = "mix"; args = [ "format" "-" ]; };
        }
        {
          name = "ruby";
          language-servers = [ "ruby-lsp" ];
        }
      ];
    };
  };

  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
    settings = {
      display = {
        compact = false;
        use_pager = true;
      };
      updates = {
        auto_update = false;
        auto_update_interval_hours = 720;
      };
    };
  };

  # Load nix dev shells into current zsh instead of spawning a subshell.
  # Use `echo "use flake" > .envrc && direnv allow` in a project with a flake.
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    package = pkgs.direnv.overrideAttrs (old: {
      doCheck = false;
    });
    config = {
      global = {
        hide_env_diff = true;
      };
    };
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
    jj-starship
    git
    gh
    delta # git-delta

    # CLI utilities
    fd
    ripgrep
    coreutils
    wget
    tree-sitter
    glow
    uv # Python project/tool manager (used for mempalace)

    # Global language support
    nixfmt
    taplo # toml

    # Common Lisp (RTM/PG style: SBCL + readline-wrapped REPL)
    sbcl
    rlwrap

    # Clojure (for working through *On Lisp* in a modern Lisp)
    clojure # `clj` / `clojure` CLI + deps.edn
    clojure-lsp
    clj-kondo # static linter
    babashka # fast-startup Clojure for scripts (`bb`)

    # Nix
    nil

    # Fonts (terminal experimentation)
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.geist-mono
    nerd-fonts.hack
    nerd-fonts.commit-mono

    # AI
    claude-code
    opencode
    # basecamp-cli upstream requires go 1.26.4; nixpkgs currently ships 1.26.3.
    # Patch the go.mod directive down so the build succeeds with what we have.
    (basecamp-cli.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace go.mod --replace-fail "go 1.26.4" "go 1.26.3"
      '';
      vendorHash = "sha256-j48iZ53SRswAi+Gd4U1fQ9flZ0blPZnuqU0U5vCELOg=";
    }))

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

  # Make uv-installed tool binaries (e.g. mempalace) discoverable on PATH.
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
