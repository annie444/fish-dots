function _fzf_compgen_path
    bfs -L . -exclude -path "*.git*" -name $argv
end
