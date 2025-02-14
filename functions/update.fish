function update -a cmd -d "Update various tools"
    argparse --name update -s h/help -- $argv
    echo "Debug argv: '$argv', cmd: '$cmd', flag_h: '$flag_h', flag_help '$flag_help'" >&2
    switch $cmd
        case chezmoi
            _update_chezmoi $flag_h $flag_help $argv
        case asdf
            _update_asdf $flag_h $flag_help $argv
        case neovim nvim
            _update_neovim $flag_h $flag_help $argv
        case fish
            _update_fish $flag_h $flag_help $argv
        case all
            _update_chezmoi $flag_h $flag_help $argv
            _update_asdf $flag_h $flag_help $argv
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
    return $status
end

function _update_chezmoi -d "Update chezmoi"
    argparse --name "update chezmoi" h/help -- $argv
    echo "Debug argv: '$argv', flag_h: '$flag_h', flag_help '$flag_help'" >&2
    if test -n "$_flag_h" -o -n "$_flag_help"
        echo "Updates chezmoi with `chezmoi update'." >&2
        return 1
    end
    chezmoi update --recursive --recurse-submodules
    cd $_starting_dir
    set --erase _starting_dir
    return $status
end

function _update_asdf -d "Update asdf"
    argparse --name "update asdf" h/help -- $argv
    echo "Debug argv: '$argv', flag_h: '$flag_h', flag_help '$flag_help'" >&2
    if test -n "$_flag_h" -o -n "$_flag_help"
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
    cd $_starting_dir
    set --erase _starting_dir
    return $status
end

function _update_neovim -d "Update neovim"
    argparse --name "update neovim" h/help -- $argv
    echo "Debug argv: '$argv', flag_h: '$flag_h', flag_help '$flag_help'" >&2
    if test -n "$_flag_h" -o -n "$_flag_help"
        echo "Updates the neovim configuration by syncing" >&2
        echo "`~/.dotfiles/nvim-dots'" >&2
        echo "with the chezmoi nvim configs" >&2
        return 1
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
    return $status
end

function _update_fish -d "Update fish"
    argparse --name "update fish" h/help -- $argv
    echo "Debug argv: '$argv', flag_h: '$flag_h', flag_help '$flag_help'" >&2
    if test -n "$_flag_h" -o -n "$_flag_help"
        echo "Updates the fish configuration by syncing" >&2
        echo "`~/.dotfiles/fish-dots'" >&2
        echo "with the chezmoi fish configs" >&2
        return 1
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
    return $status
end
