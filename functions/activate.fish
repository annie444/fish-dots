function activate
    set -l cwd (pwd -P)
    source "$cwd/.venv/bin/activate.fish"
    set --erase cwd
end
