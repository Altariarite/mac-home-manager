function jj-sync --description "Fetch from remote and rebase onto main"
    jj git fetch; and jj rebase -d main
end
