function _echo_help
    set msg $argv[-1]
    argparse b/background o/bold d/dim i/italics u/underline r/reverse n/newline c/color= -- $argv[1..-2]
    if test -n "$_flag_b" -o -n "$_flag_o" -o -n "$_flag_d" -o -n "$_flag_i" -o -n "$_flag_u" -o -n "$_flag_r" -o -n "$_flag_c"
        set_color $_flag_b $_flag_o $_flag_d $_flag_i $_flag_u $_flag_r $_flag_c
    end
    echo $_flag_n $msg >&2
    set_color normal
end

function _update_usage
    _echo_help -n -o -c magenta "Usage: "
    _echo_help -n -c cyan "update "
    _echo_help -n -c yellow "[-h|--help] "
    _echo_help -c green "<target>"
    _echo_help ""
    _echo_help "Update various tools and configurations."
    _echo_help ""
    _echo_help -o -c magenta "Flags:"
    _echo_help -n -c yellow "    -h"
    _echo_help -n ", "
    _echo_help -n -c yellow "--help    "
    _echo_help -d "Show this help message and exit"
    _echo_help ""
    _echo_help -o -c magenta "Supported targets:"
    _echo_help -n -c green "    chezmoi   "
    _echo_help -n -i -d "(alias: "
    _echo_help -n -i -c green chez
    _echo_help -i -d ")"
    _echo_help -c green "    asdf"
    _echo_help -n -c green "    neovim    "
    _echo_help -n -i -d "(alias: "
    _echo_help -n -i -c green nvim
    _echo_help -i -d ")"
    _echo_help -n -c green "    fishshell "
    _echo_help -n -i -d "(alias: "
    _echo_help -n -i -c green fish
    _echo_help -i -d ")"
    _echo_help -n -c green "    wezterm   "
    _echo_help -n -i -d "(alias: "
    _echo_help -n -i -c green wez
    _echo_help -i -d ")"
    _echo_help -n -c green "    homebrew  "
    _echo_help -n -i -d "(alias: "
    _echo_help -n -i -c green brew
    _echo_help -n -i -d ")  "
    _echo_help -i -d "[macOS only]"
    _echo_help -c green "    all"
    _echo_help ""
    _echo_help -n -o -c magenta "NOTE: "
    _echo_help "The neovim, fish, and wezterm targets will commit and push all changes"
    _echo_help -n "from the local dotfiles in the '"
    _echo_help -n -c green "~/.dotfiles"
    _echo_help "' directory then update the chezmoi repo."
end

function update -d "Update various tools"
    set -l cmd (string lower "$argv[1]")
    argparse --name update -s h/help -- $argv
    if test -z "$cmd"
        if set -ql _flag_h
            _update_usage
            return 0
        else
            _echo_help -n -o -c red "Error: "
            _echo_help "No update target specified."
            _update_usage
            return 1
        end
    end
    switch $cmd
        case chezmoi chez
            _update_chezmoi $_flag_h $_flag_help $argv
        case asdf
            _update_asdf $_flag_h $_flag_help $argv
        case neovim nvim
            _update_neovim $_flag_h $_flag_help $argv
        case fish fishshell
            _update_fish $_flag_h $_flag_help $argv
        case wezterm wez
            _update_wezterm $_flag_h $_flag_help $argv
        case brew homebrew
            if test (uname) != Darwin
                echo "The brew update target is only supported on macOS." >&2
                return 1
            end
            _update_brew $_flag_h $_flag_help $argv
        case all
            _partial_fish $_flag_h $_flag_help $argv
            _partial_neovim $_flag_h $_flag_help $argv
            _partial_wezterm $_flag_h $_flag_help $argv
            _update_chezmoi $_flag_h $_flag_help $argv
            _update_asdf $_flag_h $_flag_help $argv
        case *
            _echo_help -n -o -c red "Error: "
            _echo_help -n "Unknown update target: "
            _echo_help -i -c FF79C6 "$cmd"
            _echo_help ""
            _update_usage
            return 1
    end
    return $status
end

function _update_brew -d "Update Homebrew"
    argparse --name "update brew" h/help -- $argv
    if set -ql _flag_h
        _echo_help -n -o -c magenta "Usage: "
        _echo_help -n -c cyan update
        _echo_help -n -c FFB86C "homebrew "
        _echo_help -c yellow "[-h|--help]"
        _echo_help ""
        _echo_help "Updates Homebrew and all installed packages."
        return 0
    end
    set -f follow_status 0
    brew cleanup
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    brew update
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    brew upgrade
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    brew autoremove
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    brew cleanup
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    return $follow_status
end

function _update_chezmoi -d "Update chezmoi"
    argparse --name "update chezmoi" h/help -- $argv
    if set -ql _flag_h
        _echo_help -n -o -c magenta "Usage: "
        _echo_help -n -c cyan "update "
        _echo_help -n -c FFB86C "chezmoi "
        _echo_help -c yellow "[-h|--help]"
        _echo_help ""
        _echo_help -n "Updates chezmoi with '"
        _echo_help -n -c cyan "chezmoi "
        _echo_help -n -c FFB86C update
        _echo_help "'."
        return 0
    end
    chezmoi update --recursive --recurse-submodules
    return $status
end

function _update_asdf -d "Update asdf"
    argparse --name "update asdf" h/help -- $argv
    if set -ql _flag_h
        _echo_help -n -o -c magenta "Usage: "
        _echo_help -n -c cyan "update "
        _echo_help -n -c FFB86C "asdf "
        _echo_help -c yellow "[-h|--help]"
        _echo_help ""
        _echo_help -n "Updates asdf plugins with  '"
        _echo_help -n -c cyan "asdf "
        _echo_help -n -c FFB86C "plugin update "
        _echo_help -n -c yellow --all
        _echo_help "',"
        _echo_help -n "and updates packages that are out of date in '"
        _echo_help -n -c green "~/.tool-versions"
        _echo_help "'."
        return 0
    end
    set -f follow_status 0
    asdf plugin update --all
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    set -f _update_plugins (asdf latest --all | grep missing | awk '{print $1}')
    set -f _update_versions (asdf latest --all | grep missing | awk '{print $2}')
    for plugin in (seq (count $_update_plugins))
        asdf install $_update_plugins[$plugin] $_update_versions[$plugin]
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        asdf set --home $_update_plugins[$plugin] $_update_versions[$plugin]
        if test $status -gt $follow_status
            set -f follow_status $status
        end
    end
    return $follow_status
end

function _partial_neovim -d "Pushes changes to nvim-dots and updates chezmoi's neovim configs"
    argparse --name "update neovim" h/help -- $argv
    if set -ql _flag_h
        _echo_help -n -o -c magenta "Usage: "
        _echo_help -n -c cyan "update "
        _echo_help -n -c FFB86C "neovim "
        _echo_help -c yellow "[-h|--help]"
        _echo_help ""
        _echo_help -n "Updates the neovim configuration by syncing  '"
        _echo_help -n -c green "~/.dotfiles/nvim-dots"
        _echo_help "' with the chezmoi nvim configs."
        return 0
    end
    set -f follow_status 0
    begin
        set -f _local_starting_dir (pwd)
        set -f NOW (date "+%Y-%m-%d %H:%M:%S")
        cd ~/.dotfiles/nvim-dots
        git add -A
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git commit -m "[$NOW] (update neovim) Committing all changes to nvim-dots"
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git push
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd ~/.local/share/chezmoi/dot_config/nvim
        git pull origin main
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd ~/.local/share/chezmoi
        git add -A
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git commit -m "[$NOW] (update neovim) Pulling changes from nvim-dots"
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git push
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd $_local_starting_dir
    end
    return $follow_status
end

function _update_neovim -d "Update neovim"
    set -f follow_status 0
    _partial_neovim $argv
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    _update_chezmoi
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    return $follow_status
end

function _partial_fish -d "Pushes changes to fish-dots and updates chezmoi's fish configs"
    argparse --name "update fish" h/help -- $argv
    if set -ql _flag_h
        _echo_help -n -o -c magenta "Usage: "
        _echo_help -n -c cyan "update "
        _echo_help -n -c FFB86C "fishshell "
        _echo_help -c yellow "[-h|--help]"
        _echo_help ""
        _echo_help -n "Updates the fish configuration by syncing  '"
        _echo_help -n -c green "~/.dotfiles/fish-dots"
        _echo_help "' with the chezmoi fish configs."
        return 0
    end
    set -f follow_status 0
    begin
        set -f _local_starting_dir (pwd)
        set -f NOW (date "+%Y-%m-%d %H:%M:%S")
        cd ~/.dotfiles/fish-dots
        git add -A
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git commit -m "[$NOW] (update fish) Committing all changes to fish-dots"
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git pull
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git submodule update --recursive --init
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd completions/
        git pull origin main
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd ..
        git add -A
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git commit -m "[$NOW] (update fish) Committing all changes to fish-completions"
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git push
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd ~/.local/share/chezmoi/dot_config/fish
        git pull origin main
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git submodule update --recursive
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd ~/.local/share/chezmoi
        git add -A
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git commit -m "[$NOW] (update fish) Pulling changes from fish-dots"
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git push
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd $_local_starting_dir
    end
    return $follow_status
end

function _update_fish -d "Update fish"
    set -f follow_status 0
    _partial_fish $argv
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    _update_chezmoi
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    return $follow_status
end

function _partial_wezterm -d "Pushes changes to wezterm-dots and updates chezmoi's wezterm configs"
    argparse --name "update wezterm" h/help -- $argv
    if set -ql _flag_h
        _echo_help -n -o -c magenta "Usage: "
        _echo_help -n -c cyan "update "
        _echo_help -n -c FFB86C "wezterm "
        _echo_help -c yellow "[-h|--help]"
        _echo_help ""
        _echo_help -n "Updates the wezterm configuration by syncing  '"
        _echo_help -n -c green "~/.dotfiles/wezterm-dots"
        _echo_help "' with the chezmoi wezterm configs."
        return 0
    end
    set -f follow_status 0
    begin
        set -f _local_starting_dir (pwd)
        set -f NOW (date "+%Y-%m-%d %H:%M:%S")
        cd ~/.dotfiles/wezterm-dots
        git add -A
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git commit -m "[$NOW] (update wezterm) Committing all changes to wezterm-dots"
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git push
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd ~/.local/share/chezmoi/dot_config/wezterm
        git pull origin main
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd ~/.local/share/chezmoi
        git add -A
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git commit -m "[$NOW] (update wezterm) Pulling changes from wezterm-dots"
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        git push
        if test $status -gt $follow_status
            set -f follow_status $status
        end
        cd $_local_starting_dir
    end
    return $follow_status
end

function _update_wezterm -d "Update wezterm"
    set -f follow_status 0
    _partial_wezterm $argv
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    _update_chezmoi
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    return $follow_status
end
