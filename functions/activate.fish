function activate --description 'Activate the Python virtual environment in the current or git root directory'
    set -l cwd (pwd -P)
    set -l git_dir (git -C "$cwd" rev-parse --show-toplevel 2>&1)

    if test -d "$cwd/.venv"
        source "$cwd/.venv/bin/activate.fish"
    else if string match -q 'fatal*' "$git_dir"
        echo "Not a git repository and no .venv directory found in the current directory." >&2
        return 1
    else if test -d "$git_dir/.venv"
        source "$git_dir/.venv/bin/activate.fish"
    else
        echo "No .venv directory found in the current or git root directory." >&2
        return 1
    end
end
