function script --description 'Activate the Python virtual environment for a uv script' -a script_name
    set -l cwd (pwd -P)
    set -l script_out (uv sync --script "$cwd/$script_name" 2>&1)
    set -l script_split (string split ' ' "$script_out[1]")
    for line in $script_out
        echo $line
    end
    source "$script_split[-1]/bin/activate.fish"
end
