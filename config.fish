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
    /opt/homebrew/opt/coreutils/libexec/gnubin \
    /opt/homebrew/opt/coreutils/bin \
    /opt/homebrew/sbin \
    /opt/homebrew/bin \
    $ASDF_DATA_DIR/shims \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/bin
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
    alias ls 'eza -1GghmMoXr --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 10'
    alias la 'eza -1GghmMoXrla --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 100'
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
    set -gx HOMEBREW_CURL_RETRIES 3
    set -gx HOMEBREW_CURL_VERBOSE 1
    set -gx HOMEBREW_DEVELOPER 1
    set -gx HOMEBREW_DISPLAY_INSTALL_TIMES 1
    set -gx HOMEBREW_EDITOR nvim
    set -gx HOMEBREW_FAIL_LOG_LINES 54
    set -gx HOMEBREW_GITHUB_PACKAGES_USER annie444
    set -gx HOMEBREW_GIT_COMMITTER_EMAIL "annie.ehler.4@gmail.com"
    set -gx HOMEBREW_GIT_COMMITTER_NAME "Annie Ehler"
    set -gx HOMEBREW_GIT_EMAIL "annie.ehler.4@gmail.com"
    set -gx HOMEBREW_GIT_NAME "Annie Ehler"
    set -gx HOMEBREW_VERBOSE 1
    set -gx HOMEBREW_VERIFY_ATTESTATIONS 1

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
