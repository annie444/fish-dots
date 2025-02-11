# Environment Config
set -gx fish_term24bit 1
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx COLORTERM "truecolor"
set -gx TERM "xterm-256color"
set -gx PAGER "less"
set -gx ASDF_DATA_DIR "$HOME/.asdf"

function add_path
  set -l path $argv
  if not contains $path $PATH
    set -gx --prepend PATH $path
  end
end

# Homebrew paths
set _coreutils_path "/opt/homebrew/opt/coreutils/bin"
if test -d $_coreutils_path
  add_path $_coreutils_path
  add_path  "/opt/homebrew/opt/coreutils/libexec/gnubin"
end
set --erase _coreutils_path

# ASDF configuration code
set _asdf_shims "$ASDF_DATA_DIR/shims"
add_path $_asdf_shims
set --erase _asdf_shims

# Add local bin to path
set _local_bin_path "$HOME/.local/bin"
add_path $_local_bin_path
set --erase _local_bin_path

# Add cargo to path
set _cargo_bin_path "$HOME/.cargo/bin"
add_path $_cargo_bin_path
set --erase _cargo_bin_path

# Local environment config
direnv hook fish | source

# GPG Config
if not pgrep -x -u "$USER" gpg-agent &> /dev/null
  gpg-connect-agent /bye &> /dev/null
end

# Set GPG TTY as stated in 'man gpg-agent'
set -gx GPG_TTY (tty)

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye > /dev/null

status --is-interactive; and begin
    # Fish Config
    fish_config theme choose "Dracula Official"
    set -gx fish_greeting ""

    # Plugins
    zoxide init fish | source
    thefuck --alias | source
    batman --export-env | source
    starship init fish | source
    eval (batpipe)

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
    alias cd 'z'
    alias '..' 'z ..'
    alias ls 'eza -1GghmMoXr --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 10'
    alias la 'eza -1GghmMoXrla --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 100'
    alias ssh 'ssh'
    alias esp ". $HOME/esp/esp-idf/export.fish"
    alias note "nvim -c ':ObsidianToday<CR>'"
    alias vimdiff "nvim -d"
    alias bathelp "bat --plain --language=help"
    
    function help
      $argv --help 2>&1 | bathelp
    end

    function activate
      set -l cwd (pwd -P)
      source "$cwd/.venv/bin/activate.fish"
    end

    # Homebrew
    if test -d /opt/homebrew; or test -d /home/linuxbrew/.linuxbrew
      set -gx HOMEBREW_AUTO_UPDATE_SECS 86400
    end
    if test -d "/opt/homebrew/share/fish/completions"
      set -p fish_complete_path (brew --prefix)/share/fish/completions
      set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end

    if test -d $HOME/.config/jenkins
      source $HOME/.config/jenkins/creds.fish
    end

    # FZF Config
    fzf --fish | source
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
    function _fzf_comprun
      set -l command $argv[1]
      set -e $argv[1]
      switch $command
        case cd
          fzf --preview 'tree -C {} | head -200' "$argv"
        case 'export|unset'
          fzf --preview "eval 'echo \$'{}" "$argv"
        case ssh
          fzf --preview 'dig {}' "$argv"
        case '*'
          fzf --preview 'bat -n --color=always {}' "$argv"
      end
    end
    function _fzf_compgen_path
      bfs -L . -exclude -path "*.git*" -name $argv
    end
    function _fzf_compgen_dir
      bfs -L . -type d -exclude -path "*.git*" $argv
    end

    # Kitty config
    if set -q KITTY_INSTALLATION_DIR
      source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
      set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end

    # LaTeX config
    if test -d "/usr/local/texlive/2024"
      set -gx MANPATH "/usr/local/texlive/2024/texmf-dist/doc/man" $MANPATH
      set -gx INFOPATH "/usr/local/texlive/2024/texmf-dist/doc/info" $INFOPATH
      set -gx PATH "/usr/local/texlive/2024/bin/x86_64-linux" $PATH
    end

    # Bat config
    set -gx BAT_THEME "Dracula"
    set -gx BATPIPE "color"
    set -gx BATDIFF_USE_DELTA true
    
    # 1Password config
    if test -e "$HOME/.config/op/plugins.sh"
      source "$HOME/.config/op/plugins.sh"
    end
end

# GCloud paths
if test -f $HOME/.gcloud/path.fish.inc
  source $HOME/.gcloud/path.fish.inc
end

# UV options
set -gx UV_PYTHON_PREFERENCE "only-managed"
set -gx UV_LINK_MODE "symlink"
set -gx UV_PRERELEASE "if-necessary-or-explicit"

# Override apptainer for macOS
if test (uname) = "Darwin"
  alias apptainer "limactl shell apptainer"
end

# Environment Config
set -g fish_term24bit 1
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx COLORTERM "truecolor"
set -gx TERM "xterm-256color"
set -gx PAGER "less"
