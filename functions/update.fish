function update -a cmd -a flag -d "Update various tools"
    switch $cmd
        case chezmoi
            _update_chezmoi $flag
        case asdf
            _update_asdf
        case neovim nvim
            _update_neovim
        case fish
            _update_fish
        case all
            _update_chezmoi
            _update_asdf
        case *
            echo "Unknown update target: $cmd" >&2
            echo "Supported targets:" >&2
            echo "    chezmoi" >&2
            echo "    asdf" >&2
            echo "    neovim (alias: nvim)" >&2
            echo "    fish" >&2
            echo "    all (alias for chezmoi and asdf)" >&2
            echo "" >&2
            echo "The neovim and fish targets will commit and push all changes from the local" >&2
            echo "dotfiles in the `~/.dotfiles' directory then update the chezmoi repo." >&2
            return 1
    end
    return $status
end

function _update_chezmoi -a flag -d "Update chezmoi"
    if test $flag = --help; or test $flag = -h
        echo "Updates chezmoi with `chezmoi update'." >&2
        return 1
    end
    chezmoi update --recursive --recurse-submodules
    return $status
end

function _update_asdf -a flag -d "Update asdf"
    if test $flag = --help; or test $flag = -h
        echo "Updates asdf plugins with `asdf plugin update --all'." >&2
        echo "Also updates packages that are out of date in `~/.tool-versions'." >&2
        return 1
    end
    asdf plugin update --all
    set -f _update_plugins (asdf latest --all | grep missing | awk '{print $1}')
    for plugin in $_update_plugins
        asdf install $plugin latest
        asdf set $plugin latest
    end
    return $status
end

function _update_neovim -a flag -d "Update neovim"
    if test $flag = --help; or test $flag = -h
        echo "Updates the neovim configuration by syncing" >&2
        echo "`~/.dotfiles/nvim-dots'" >&2
        echo "with the chezmoi nvim configs" >&2
        return 1
    end
    begin
        set -f PWD (pwd)
        set -f NOW (date "+%Y-%m-%d %H:%M:%S")
        cd ~/.dotfiles/nvim-dots
        git add -A
        git commit -m "[$NOW] (update neovim) Committing all changes to nvim-dots"
        git push
        cd ~/.local/share/chezmoi/dot_config/nvim
        git pull
        cd ~/.local/share/chezmoi
        git add -A
        git commit -m "[$NOW] (update neovim) Pulling changes from nvim-dots"
        git push
        cd $PWD
    end
    _update_chezmoi
    return $status
end

function _update_fish -a flag -d "Update fish"
    if test $flag = --help; or test $flag = -h
        echo "Updates the fish configuration by syncing" >&2
        echo "`~/.dotfiles/fish-dots'" >&2
        echo "with the chezmoi fish configs" >&2
        return 1
    end
    begin
        set -f PWD (pwd)
        set -f NOW (date "+%Y-%m-%d %H:%M:%S")
        cd ~/.dotfiles/fish-dots
        git add -A
        git commit -m "[$NOW] (update fish) Committing all changes to fish-dots"
        git push
        cd ~/.local/share/chezmoi/dot_config/fish
        git pull
        cd ~/.local/share/chezmoi
        git add -A
        git commit -m "[$NOW] (update fish) Pulling changes from fish-dots"
        git push
        cd $PWD
    end
    _update_chezmoi
    return $status
end
