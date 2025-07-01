function update -a cmd -d "Update various tools"
    argparse --name update -s h/help -- $argv
    switch $cmd
        case chezmoi
            _update_chezmoi $flag_h $flag_help $argv
        case asdf
            _update_asdf $flag_h $flag_help $argv
        case neovim nvim
            _update_neovim $flag_h $flag_help $argv
        case fish
            _update_fish $flag_h $flag_help $argv
        case brew
            _update_brew $flag_h $flag_help $argv
        case all
            _partial_fish $flag_h $flag_help $argv
            _partial_neovim $flag_h $flag_help $argv
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
    return $status
end

function _update_brew -d "Update Homebrew"
    argparse --name "update brew" h/help -- $argv
    if test -n "$_flag_h" -o -n "$_flag_help"
        echo "Updates Homebrew and all installed packages." >&2
        return 1
    end
    brew cleanup
    brew update
    brew upgrade
    brew autoremove
    brew cleanup
    return $status
end

function _update_chezmoi -d "Update chezmoi"
    argparse --name "update chezmoi" h/help -- $argv
    if test -n "$_flag_h" -o -n "$_flag_help"
        echo "Updates chezmoi with `chezmoi update'." >&2
        return 1
    end
    chezmoi update --recursive --recurse-submodules
    return $status
end

function _update_asdf -d "Update asdf"
    argparse --name "update asdf" h/help -- $argv
    if test -n "$_flag_h" -o -n "$_flag_help"
        echo "Updates asdf plugins with `asdf plugin update --all'." >&2
        echo "Also updates packages that are out of date in `~/.tool-versions'." >&2
        return 1
    end
    asdf plugin update --all
    set -f _update_plugins (asdf latest --all | grep missing | awk '{print $1}')
    set -f _update_versions (asdf latest --all | grep missing | awk '{print $2}')
    for plugin in (seq (count $_update_plugins))
        asdf install $_update_plugins[$plugin] $_update_versions[$plugin]
        asdf set --home $_update_plugins[$plugin] $_update_versions[$plugin]
    end
    return $status
end

function _update_neovim -d "Pushes changes to nvim-dots and updates chezmoi's neovim configs"
    argparse --name "partially update neovim" h/help -- $argv
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
    return $status
end

function _update_neovim -d "Update neovim"
    argparse --name "update neovim" h/help -- $argv
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
    return $status
end

function _partial_fish -d "Pushes changes to fish-dots and updates chezmoi's fish configs"
    argparse --name "partially update fish" h/help -- $argv
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
    return $status
end

function _update_fish -d "Update fish"
    argparse --name "update fish" h/help -- $argv
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
    return $status
end
