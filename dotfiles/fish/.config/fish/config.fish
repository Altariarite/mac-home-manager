if status is-interactive
    # Commands to run in interactive sessions can go here
end

# peon-ping quick controls
function peon
    bash /Users/altaria/.claude/hooks/peon-ping/peon.sh $argv
end

# Added by Antigravity
fish_add_path /Users/altaria/.antigravity/antigravity/bin
