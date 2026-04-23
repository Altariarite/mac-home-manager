if status is-interactive
    # Commands to run in interactive sessions can go here
end


# opam configuration
source /Users/altaria/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME


# peon-ping quick controls
function peon
    bash /Users/altaria/.claude/hooks/peon-ping/peon.sh $argv
end

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# Added by Antigravity
fish_add_path /Users/altaria/.antigravity/antigravity/bin

# pnpm
set -gx PNPM_HOME "/Users/altaria/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /Users/altaria/.ghcup/bin $PATH # ghcup-env