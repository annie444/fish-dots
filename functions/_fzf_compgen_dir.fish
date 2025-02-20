function _fzf_compgen_dir
    bfs -L . -type d -exclude -path "*.git*" $argv
end
