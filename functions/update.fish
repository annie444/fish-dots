function update -a cmd -d "Update various tools"
    set -gx _starting_dir (pwd)
    if test (count $argv) -eq 2
        set -g flag $argv[2]
    end
    switch $cmd
        case chezmoi
            _update_chezmoi $flag
        case asdf
            _update_asdf $flag
        case neovim nvim
            _update_neovim $flag
        case fish
            _update_fish $flag
        case all
            _update_chezmoi $flag
            _update_asdf $flag
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
    cd $_starting_dir
    set --erase _starting_dir
    set --erase flag
    return $status
end

function _update_chezmoi -d "Update chezmoi"
    if test (count $argv) -eq 1
        set -g flag $argv[1]
    end
    if test -n $flag
        if test $flag = "--help"; or test $flag = "-h"
            echo "Updates chezmoi with `chezmoi update'." >&2
            return 1
        end
    end
    chezmoi update --recursive --recurse-submodules
    cd $_starting_dir
    set --erase _starting_dir
    set --erase flag
    return $status
end

function _update_asdf -d "Update asdf"
    if test (count $argv) -eq 1
        set -g flag $argv[1]
    end
    if test -n flag 
        if test $flag = "--help"; or test $flag = "-h"
            echo "Updates asdf plugins with `asdf plugin update --all'." >&2
            echo "Also updates packages that are out of date in `~/.tool-versions'." >&2
            return 1
        end
    end
    asdf plugin update --all
    set -f _update_plugins (asdf latest --all | grep missing | awk '{print $1}')
    for plugin in $_update_plugins
        asdf install $plugin latest
        asdf set $plugin latest
    end
    cd $_starting_dir
    set --erase _starting_dir
    set --erase flag
    return $status
end

function _update_neovim -d "Update neovim"
    if test (count $argv) -eq 1
        set -g flag $argv[1]
    end
    if test -n $flag
        if test $flag = "--help"; or test $flag = "-h"
            echo "Updates the neovim configuration by syncing" >&2
            echo "`~/.dotfiles/nvim-dots'" >&2
            echo "with the chezmoi nvim configs" >&2
            return 1
        end
    end
    begin
        set -f _local_starting_dir (pwd)
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
        cd $_local_starting_dir
    end
    _update_chezmoi
    cd $_starting_dir
    set --erase _starting_dir
    set --erase NOW
    set --erase flag
    return $status
end

function _update_fish -d "Update fish"
    if test (count $argv) -eq 1
        set -g flag $argv[1]
    end
    if test -n $flag
        if test $flag = "--help"; or test $flag = "-h"
            echo "Updates the fish configuration by syncing" >&2
            echo "`~/.dotfiles/fish-dots'" >&2
            echo "with the chezmoi fish configs" >&2
            return 1
        end
    end
    begin
        set -f _local_starting_dir (pwd)
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
        cd $_local_starting_dir
    end
    _update_chezmoi
    cd $_starting_dir
    set --erase _starting_dir
    set --erase NOW
    set --erase flag
    return $status
end
