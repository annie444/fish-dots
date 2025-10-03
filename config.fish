function add_path
    set -l path $argv
    if not contains $path $PATH
        set -gx --prepend PATH $path
    end
end

function test_add_path
    set -l path $argv
    if test -d $path
        add_path $path
    end
end

function add_complete
    set -l path $argv
    if not contains $path $fish_complete_path
        set -gx --prepend fish_complete_path $path
    end
end

function test_add_complete
    set -l path $argv
    if test -d $path
        add_complete $path
    end
end

function add_functions
    set -l path $argv
    if not contains $path $fish_function_path
        set -gx --prepend fish_function_path $path
    end
end

function test_add_functions
    set -l path $argv
    if test -d $path
        add_complete $path
    end
end

# Set ulimits
if test (uname) = Darwin
    ulimit -n 200000
    ulimit -u 2048
end

test_add_path /opt/homebrew/bin
test_add_functions /opt/homebrew/share/fish/functions
test_add_functions /opt/homebrew/share/fish/vendor_functions.d
test_add_complete /opt/homebrew/share/fish/completions
test_add_complete /opt/homebrew/share/fish/vendor_completions.d
test_add_path $HOME/.atuin/bin

# Environment Config
set -gx fish_term24bit 1
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx COLORTERM truecolor
set -gx TERM xterm-256color
set -gx PAGER less
set -gx ASDF_DATA_DIR "$HOME/.asdf"
set -gx ASDF_CONCURRENCY (nproc)
set -gx ASDF_CONFIG_FILE "$HOME/.asdfrc"

set -g _user_paths \
    /usr/local/bin \
    /opt/homebrew/opt/coreutils/libexec/gnubin \
    /opt/homebrew/opt/coreutils/bin \
    /opt/homebrew/sbin \
    /opt/homebrew/bin \
    $HOME/.krew/bin \
    $ASDF_DATA_DIR/shims \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/bin \
    $HOME/.deno/bin \
    $HOME/Library/pnpm \
    $HOME/.local/share/pnpm
for _path in $_user_paths
    test_add_path $_path
end
set --erase _user_paths

# Local environment config
direnv hook fish | source

status --is-interactive; and begin
    # Fish Config
    fish_config theme choose "Dracula Official"
    set -gx fish_greeting ""

    # Plugins
    zoxide init fish | source
    thefuck --alias | source
    batman --export-env | source
    starship init fish | source
    fzf --fish | source
    eval (batpipe)
    atuin init fish | source

    # Aliases
    alias du dust
    alias g git
    alias vim nvim
    alias vi nvim
    alias diff batdiff
    alias gd batdiff
    alias ":q" exit
    alias k kubectl
    alias kctl kubectl
    alias cat bat
    alias bgrep batgrep
    alias bwatch batwatch
    alias find bfs
    alias cd z
    alias '..' 'z ..'
    alias ls 'eza --oneline --follow-symlinks --hyperlink --header --modified --group --mounts --octal-permissions --reverse --sort=modified --color=always --icons=always --classify=always --time-style=long-iso --git --git-repos --show-symlinks'
    alias la 'eza --oneline --follow-symlinks --hyperlink --header --modified --group --mounts --octal-permissions --reverse --sort=modified --color=always --icons=always --classify=always --time-style=long-iso --git --git-repos --show-symlinks -la'
    alias ssh ssh
    alias esp ". $HOME/esp/esp-idf/export.fish"
    alias note "nvim -c ':ObsidianToday<CR>'"
    alias vimdiff "nvim -d"
    alias bathelp "bat --plain --language=help"

    # from https://docs.brew.sh/Manpage#environment
    set -gx HOMEBREW_AUTO_UPDATE_SECS 3600
    set -gx HOMEBREW_API_AUTO_UPDATE_SECS 450
    set -gx HOMEBREW_BAT 1
    set -gx HOMEBREW_BAT_CONFIG_PATH "$HOME/.config/bat/config"
    set -gx HOMEBREW_BAT_THEME Dracula
    set -gx HOMEBREW_CLEANUP_MAX_AGE_DAYS 10
    set -gx HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS 5
    set -gx HOMEBREW_COLOR 1
    set -gx HOMEBREW_EDITOR nvim
    set -gx HOMEBREW_FAIL_LOG_LINES 1000

    # Just Config
    set -gx JUST_HIGHLIGHT true
    set -gx JUST_TIMESTAMP true
    set -gx JUST_TIMESTAMP_FORMAT "%Y-%m-%d %H:%M:%S"
    set -gx JUST_UNSTABLE true

    if test -d $HOME/.config/jenkins
        source $HOME/.config/jenkins/creds.fish
    end

    # FZF Config
    # from https://github.com/PatrickF1/fzf.fish#change-fzf-options-for-a-specific-command
    set -gx fzf_preview_dir_cmd 'eza --all --color=always'
    set -gx fzf_preview_file_cmd 'bat --style=numbers --line-range=:500s {}'
    set -gx fzf_diff_highlighter 'batdiff --paging=never --width=20'
    set -gx fzf_history_time_format "%Y-%m-%d %H:%M:%S"

    # from https://github.com/eth-p/bat-extras/blob/master/doc/batdiff.md
    set -gx BATDIFF_USE_DELTA true

    # Kitty config
    if set -q KITTY_INSTALLATION_DIR
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end

    # LaTeX config (Linux only)
    if test -d /usr/local/texlive/2024
        set -gx MANPATH /usr/local/texlive/2024/texmf-dist/doc/man $MANPATH
        set -gx INFOPATH /usr/local/texlive/2024/texmf-dist/doc/info $INFOPATH
        set -gx PATH /usr/local/texlive/2024/bin/x86_64-linux $PATH
    end

    # from https://github.com/sharkdp/bat?tab=readme-ov-file#customization
    set -gx BAT_THEME Dracula
    set -gx BATPIPE color
    set -gx BATDIFF_USE_DELTA true

    # 1Password config
    if test -e "$HOME/.config/op/plugins.sh"
        source "$HOME/.config/op/plugins.sh"
    end

    source ~/.gnupg/gpg.fish

    # Enable vi mode
    set -g fish_key_bindings fish_vi_key_bindings
    fish_vi_key_bindings

    # Load PNPM
    if test -d "$HOME/Library/pnpm"
        set -gx PNPM_HOME "$HOME/Library/pnpm"
    else if test -d "$HOME/.local/share/pnpm"
        set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    end
    if set -q PNPM_HOME
        if not string match -q -- $PNPM_HOME $PATH
            set -gx PATH "$PNPM_HOME" $PATH
        end
    end
end

# GCloud paths
if test -f $HOME/.gcloud/path.fish.inc
    source $HOME/.gcloud/path.fish.inc
end

# UV options
set -gx UV_PYTHON_PREFERENCE only-managed
set -gx UV_LINK_MODE symlink
set -gx UV_PRERELEASE if-necessary-or-explicit

# Override apptainer for macOS
if test (uname) = Darwin
    alias apptainer "limactl shell apptainer"
end

# Environment Config
set -g fish_term24bit 1
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx COLORTERM truecolor
set -gx TERM xterm-256color
set -gx PAGER less
