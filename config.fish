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
    alias cd z
    alias '..' 'z ..'
    alias ls 'eza -1GghmMoXr --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 10'
    alias la 'eza -1GghmMoXrla --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 100'
    alias ssh ssh
    alias esp ". $HOME/esp/esp-idf/export.fish"
    alias note "nvim -c ':ObsidianToday<CR>'"
    alias vimdiff "nvim -d"
    alias bathelp "bat --plain --language=help"

    # Homebrew
    set -gx HOMEBREW_AUTO_UPDATE_SECS 86400

    if test -d $HOME/.config/jenkins
        source $HOME/.config/jenkins/creds.fish
    end

    # FZF Config
    # from https://github.com/PatrickF1/fzf.fish#change-fzf-options-for-a-specific-command
    set -gx fzf_preview_dir_cmd 'tree -C {} | head -n 200'
    set -gx fzf_preview_file_cmd 'bat --color=always --style=numbers --line-range=:500s {}'
    set -gx fzf_diff_highlighter 'batdiff --paging=never --width=20'
    set -gx fzf_history_time_format "%Y-%m-%d %H:%M:%S"
    set -gx fzf_fd_opts ''

    # from https://github.com/junegunn/fzf?tab=readme-ov-file#environment-variables
    set -gx FZF_DEFAULT_COMMAND 'bfs -type f'
    set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --prompt="> " --preview-window=right:60%:wrap --preview="bat --color=always --style=numbers --line-range=:500s {}"'
    set -gx FZF_COMPLETION_TRIGGER '**'
    set -gx FZF_COMPLETION_OPTS '--border --info=inline'
    set -gx FZF_COMPLETION_PATH_OPTS '--walker file,dir,follow,hidden'
    set -gx FZF_COMPLETION_DIR_OPTS '--walker dir,hidden'

    # Kitty config
    if set -q KITTY_INSTALLATION_DIR
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end

    # LaTeX config
    if test -d /usr/local/texlive/2024
        set -gx MANPATH /usr/local/texlive/2024/texmf-dist/doc/man $MANPATH
        set -gx INFOPATH /usr/local/texlive/2024/texmf-dist/doc/info $INFOPATH
        set -gx PATH /usr/local/texlive/2024/bin/x86_64-linux $PATH
    end

    # Bat config
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
