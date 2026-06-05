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
    # All for quick access to chezmoi external config paths
    set -gx chezmoi_wezterm_path dot_config/external_wezterm
    set -gx chezmoi_fish_path dot_config/external_fish
    set -gx chezmoi_nvim_path dot_config/external_nvim

    argparse --name update h/help -- $argv
    set cmd (string lower "$argv[1]")
    if test -z "$cmd"
        if set -ql _flag_h; or set -ql _flag_help
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
            if set -ql _flag_h; or set -ql _flag_help
                _chezmoi_usage
                return 0
            end
            _update_chezmoi
        case asdf
            if set -ql _flag_h; or set -ql _flag_help
                _asdf_usage
                return 0
            end
            _update_asdf
        case neovim nvim
            if set -ql _flag_h; or set -ql _flag_help
                _neovim_usage
                return 0
            end
            _update_neovim
        case fish fishshell
            if set -ql _flag_h; or set -ql _flag_help
                _fish_usage
                return 0
            end
            _update_fish
        case wezterm wez
            if set -ql _flag_h; or set -ql _flag_help
                _wezterm_usage
                return 0
            end
            _update_wezterm
        case brew homebrew
            if test (uname) != Darwin
                echo "The brew update target is only supported on macOS." >&2
                return 1
            end
            if set -ql _flag_h; or set -ql _flag_help
                _brew_usage
                return 0
            end
            _update_brew
        case all
            if set -ql _flag_h; or set -ql _flag_help
                _update_usage
                return 0
            end
            _partial_fish
            _partial_neovim
            _partial_wezterm
            _update_chezmoi
            _update_asdf
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

function _brew_usage
    _echo_help -n -o -c magenta "Usage: "
    _echo_help -n -c cyan update
    _echo_help -n -c FFB86C "homebrew "
    _echo_help -c yellow "[-h|--help]"
    _echo_help ""
    _echo_help "Updates Homebrew and all installed packages."
end

function _update_brew -d "Update Homebrew"
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

function _chezmoi_usage
    _echo_help -n -o -c magenta "Usage: "
    _echo_help -n -c cyan "update "
    _echo_help -n -c FFB86C "chezmoi "
    _echo_help -c yellow "[-h|--help]"
    _echo_help ""
    _echo_help -n "Updates chezmoi with '"
    _echo_help -n -c cyan "chezmoi "
    _echo_help -n -c FFB86C update
    _echo_help "'."
end

function _update_chezmoi -d "Update chezmoi"
    chezmoi update --recursive --recurse-submodules
    return $status
end

function _asdf_usage
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
end

function _update_asdf -d "Update asdf"
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

function _partial_update -a dotfile_path -a cmd_name -a chezmoi_path -d "Pushes changes to dotfile and updates chezmoi's dotfile configs"
    set -f _local_starting_dir (pwd)
    set -f NOW (date "+%Y-%m-%d %H:%M:%S")
    set -f dotfile_name (basename $dotfile_path)
    set -f follow_status 0
    cd $dotfile_path
    git add -A
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    git commit -m "[$NOW] ($cmd_name) Committing all changes to $dotfile_name"
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    git pull
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    git push
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    cd ~/.local/share/chezmoi
    git pull
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    cd ~/.local/share/chezmoi/$chezmoi_path
    git pull origin main
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    git checkout main
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    cd ~/.local/share/chezmoi
    git add -A
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    git commit -m "[$NOW] ($cmd_name) Pulling changes from $dotfile_name"
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    git push
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    cd $_local_starting_dir
    return $follow_status
end

function _neovim_usage
    _echo_help -n -o -c magenta "Usage: "
    _echo_help -n -c cyan "update "
    _echo_help -n -c FFB86C "neovim "
    _echo_help -c yellow "[-h|--help]"
    _echo_help ""
    _echo_help -n "Updates the neovim configuration by syncing  '"
    _echo_help -n -c green "~/.dotfiles/nvim-dots"
    _echo_help "' with the chezmoi nvim configs."
end

function _partial_neovim -d "Pushes changes to nvim-dots and updates chezmoi's neovim configs"
    set -f follow_status 0
    _partial_update ~/.dotfiles/nvim-dots "update neovim" $chezmoi_nvim_path
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    return $follow_status
end

function _update_neovim -d "Update neovim"
    set -f follow_status 0
    _partial_neovim
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    _update_chezmoi
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    return $follow_status
end

function _fish_usage
    _echo_help -n -o -c magenta "Usage: "
    _echo_help -n -c cyan "update "
    _echo_help -n -c FFB86C "fishshell "
    _echo_help -c yellow "[-h|--help]"
    _echo_help ""
    _echo_help -n "Updates the fish configuration by syncing  '"
    _echo_help -n -c green "~/.dotfiles/fish-dots"
    _echo_help "' with the chezmoi fish configs."
end

function _partial_fish -d "Pushes changes to fish-dots and updates chezmoi's fish configs"
    set -f follow_status 0
    _partial_update ~/.dotfiles/fish-dots "update fish" $chezmoi_fish_path
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    return $follow_status
end

function _update_fish -d "Update fish"
    set -f follow_status 0
    _partial_fish
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    _update_chezmoi
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    return $follow_status
end

function _wezterm_usage
    _echo_help -n -o -c magenta "Usage: "
    _echo_help -n -c cyan "update "
    _echo_help -n -c FFB86C "wezterm "
    _echo_help -c yellow "[-h|--help]"
    _echo_help ""
    _echo_help -n "Updates the wezterm configuration by syncing  '"
    _echo_help -n -c green "~/.dotfiles/wezterm-dots"
    _echo_help "' with the chezmoi wezterm configs."
end

function _partial_wezterm -d "Pushes changes to wezterm-dots and updates chezmoi's wezterm configs"
    set -f follow_status 0
    _partial_update ~/.dotfiles/wezterm-dots "update wezterm" $chezmoi_wezterm_path
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    return $follow_status
    return $follow_status
end

function _update_wezterm -d "Update wezterm"
    set -f follow_status 0
    _partial_wezterm
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    _update_chezmoi
    if test $status -gt $follow_status
        set -f follow_status $status
    end
    return $follow_status
end
