set -gx fish_log_file "$HOME/.fish_startup.log"

echo "Sourcing config.fish on $(date '+%Y-%m-%d at %H:%M:%S')" >>$fish_log_file
function startup_log -a message
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >>$fish_log_file
end

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

function test_create_dir -a dir_path
    if not test -d $dir_path
        mkdir -p $dir_path
        chmod 0755 $dir_path
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

startup_log "Added Homebrew and Atuin paths"

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

startup_log "Set basic environment variables"

set -g _user_paths \
    /usr/local/bin \
    /usr/local/cuda-13.0/bin \
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
    $HOME/.local/share/pnpm \
    $HOME/.opencode/bin \
    $HOME/.local/share/ovftool \
    $HOME/.npm-global/bin \
    $HOME/.bun/bin \
    $HOME/.cache/.bun/bin
for _path in $_user_paths
    test_add_path $_path
end
set --erase _user_paths

startup_log "Configured user paths"

# Local environment config
direnv hook fish | source

startup_log "Sourced direnv hook"

status --is-interactive; and begin
    # Fish Config
    fish_config theme choose "Dracula Official"
    set -U fish_greeting ""
    startup_log "Configured fish theme"

    # Plugins
    zoxide init fish | source
    startup_log "Sourced zoxide init"
    thefuck --alias | source
    startup_log "Sourced thefuck"
    batman --export-env | source
    startup_log "Sourced batman"
    starship init fish | source
    startup_log "Sourced starship"
    fzf --fish | source
    startup_log "Sourced FZF"
    eval (batpipe)
    startup_log "Sourced batpipe"
    atuin init fish | source
    startup_log "Sourced atuin"

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
    startup_log "Configured aliases"

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
    startup_log "Configured Homebrew environment variables"

    # Just Config
    set -gx JUST_HIGHLIGHT true
    set -gx JUST_TIMESTAMP true
    set -gx JUST_TIMESTAMP_FORMAT "%Y-%m-%d %H:%M:%S"
    set -gx JUST_UNSTABLE true
    startup_log "Configured Just environment variables"

    # Jenkins Credentials
    if test -d $HOME/.config/jenkins
        source $HOME/.config/jenkins/creds.fish
        startup_log "Sourced Jenkins credentials"
    end
    startup_log "Configured Jenkins credentials"

    # FZF Config
    # from https://github.com/PatrickF1/fzf.fish#change-fzf-options-for-a-specific-command
    set -gx fzf_preview_dir_cmd eza --all --follow-symlinks --sort=name --color=always --icons=always --classify=always --show-symlinks --oneline
    set -gx fzf_preview_file_cmd bat --style=numbers
    set -gx fzf_fd_opts --hidden --max-depth 5
    set -gx fzf_git_log_format "format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)'"
    set -gx fzf_diff_highlighter delta --paging=never --width=20
    set -gx fzf_history_time_format "%Y-%m-%d %H:%M:%S"
    startup_log "Configured patrickf1/fzf.fish plugin environment variables"

    # franciscolourenco/done config
    set -U __done_min_cmd_duration 3000 # milliseconds
    set -U __done_exclude "^git (?!push|pull|fetch)"
    if test (uname -s) = Darwin
        set -U __done_notification_command "terminal-notifier -title 'Command completed' -subtitle \"\$title\" -message \"\$message\" -group \"\$ATUIN_SESSION\" -activate 'com.github.wez.wezterm' -sender 'com.github.wez.wezterm' -ignoreDnD"
    end
    startup_log "Configured franciscolourenco/done plugin environment variables"

    # from https://github.com/eth-p/bat-extras/blob/master/doc/batdiff.md
    # from https://github.com/sharkdp/bat?tab=readme-ov-file#customization
    set -gx BATDIFF_USE_DELTA true
    set -gx BAT_THEME Dracula
    set -gx BATPIPE color
    startup_log "Configured BAT environment variables"

    # 1Password config
    if test -e "$HOME/.config/op/plugins.sh"
        source "$HOME/.config/op/plugins.sh"
        startup_log "Sourced 1Password plugins"
    end
    startup_log "Configured 1Password"

    source ~/.gnupg/gpg.fish
    startup_log "Configured GPG and the GPG agent"

    # Enable vi mode
    set -g fish_key_bindings fish_vi_key_bindings
    fish_vi_key_bindings
    startup_log "Set fish to use vi key bindings"

    # Load PNPM
    if test -d "$HOME/Library/pnpm"
        set -gx PNPM_HOME "$HOME/Library/pnpm"
    else if test -d "$HOME/.local/share/pnpm"
        set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    end
    if set -q PNPM_HOME
        if not string match -q -- $PNPM_HOME $PATH
            set -gx PATH "$PNPM_HOME" $PATH
            startup_log "Added PNPM to the path at: $PNPM_HOME"
        end
    end
    startup_log "Configured PNPM path"
end

# GCloud paths
if test -f $HOME/.gcloud/path.fish.inc
    source $HOME/.gcloud/path.fish.inc
    startup_log "Sourced Google Cloud SDK init script"
end
startup_log "Configured Google Cloud SDK"

# UV options
set -gx UV_PYTHON_PREFERENCE only-managed
set -gx UV_LINK_MODE symlink
set -gx UV_PRERELEASE if-necessary-or-explicit
startup_log "Configured UV environment variables"

# Override apptainer for macOS
if test (uname) = Darwin
    alias apptainer "limactl shell apptainer"
    startup_log "Set apptainer alias for macOS"
end
startup_log "Configured apptainer alias"

# Environment Config
set -g fish_term24bit 1
set -gx EDITOR nvim
set -gx COLORTERM truecolor
set -gx TERM xterm-256color
set -gx PAGER less
startup_log "Re-set basic environment variables"

# XDG paths
if set -q XDG_CONFIG_HOME
    set -gx XDG_CONFIG_HOME "$XDG_CONFIG_HOME"
else
    set -gx XDG_CONFIG_HOME "$HOME/.config"
end
if set -q XDG_CACHE_HOME
    set -gx XDG_CACHE_HOME "$XDG_CACHE_HOME"
else
    set -gx XDG_CACHE_HOME "$HOME/.cache"
end
if set -q XDG_DATA_HOME
    set -gx XDG_DATA_HOME "$XDG_DATA_HOME"
else
    set -gx XDG_DATA_HOME "$HOME/.local/share"
end
if set -q XDG_STATE_HOME
    set -gx XDG_STATE_HOME "$XDG_STATE_HOME"
else
    set -gx XDG_STATE_HOME "$HOME/.local/state"
end
test_create_dir $XDG_CONFIG_HOME
test_create_dir $XDG_CACHE_HOME
test_create_dir $XDG_DATA_HOME
test_create_dir $XDG_STATE_HOME
startup_log "Set XDG base directories"
