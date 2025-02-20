function _fzf_comprun
    set -l command $argv[1]
    set -e $argv[1]
    switch $command
        case cd
            fzf --preview 'tree -C {} | head -200' "$argv"
        case 'export|unset'
            fzf --preview "eval 'echo \$'{}" "$argv"
        case ssh
            fzf --preview 'dig {}' "$argv"
        case '*'
            fzf --preview 'bat -n --color=always {}' "$argv"
    end
end
