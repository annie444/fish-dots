set -U fish_term24bit 1

zoxide init fish | source

direnv hook fish | source

set -U EDITOR nvim

status --is-interactive; and begin
    # Aliases
    fish_config theme choose "Dracula Official"

    set -gx GPG_TTY (tty)
    thefuck --alias | source
    batman --export-env | source
    eval (batpipe)

    abbr -a du dust
    abbr -a g git
    abbr -a vim nvim
    abbr -a vi nvim
    abbr -a diff batdiff
    abbr -a gd batdiff
    abbr -a ":q" exit
    abbr -a k kubectl
    abbr -a cat bat
    abbr -a tp trash-put
    abbr -a te trash-empty
    abbr -a tl trash-list
    abbr -a tre trash-restore
    abbr -a trm trash-rm
    abbr -a grep batgrep
    abbr -a watch batwatch

    alias cd 'z'
    alias '..' 'z ..'
    alias ls 'eza -1GghmMoXr --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 10'
    alias la 'eza -1GghmMoXrla --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 100'
    alias ssh 'kitten ssh'
    alias esp ". $HOME/esp/esp-idf/export.fish"
    alias note "nvim -c ':ObsidianToday<CR>'"
    alias vimdiff "nvim -d"
    alias bathelp "bat --plain --language=help"

    if test -d /opt/homebrew/bin
      alias git '/opt/homebrew/bin/git'
    end

    if test "$(uname)" = "Darwin"
      alias apptainer "limactl shell apptainer"
    end
    set -gx fish_greeting ""

    # Set up fzf key bindings
    fzf --fish | source

    # FZF Config
    # from https://github.com/PatrickF1/fzf.fish#change-fzf-options-for-a-specific-command
    set -gx fzf_preview_dir_cmd 'tre -C {} | head -n 200'
    set -gx fzf_preview_file_cmd 'bat --color=always --style=numbers --line-range=:500s {}'
    set -gx fzf_diff_highlighter 'batdiff --paging=never --width=20'
    set -gx fzf_history_time_format "%Y-%m-%d %H:%M:%S"
    set -gx fzf_fd_opts --hidden

    # from https://github.com/junegunn/fzf?tab=readme-ov-file#environment-variables
    set -gx FZF_DEFAULT_COMMAND 'bfs . -type f -name'
    

    if set -q KITTY_INSTALLATION_DIR
      source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
      set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end

    if contains $HOME/.local/share/rmtrash $PATH
      set -gx PATH $HOME/.local/share/rmtrash $PATH
    end

    function help
      $argv --help 2>&1 | bathelp
    end

    if test -d "$HOME/.config/nvm"
      set -gx NVM_DIR "$HOME/.config/nvm"
    else if test -d "$HOME/.nvm"
      set -gx NVM_DIR "$HOME/.nvm"
    else if test -d "$HOME/nvm"
      set -gx NVM_DIR "$HOME/nvm"
    end

    if test -n "$NVM_DIR"
      set --universal nvm_default_version "lts"
      set --universal nvm_default_packages tree-sitter-cli pnpm auto-changelog
      if test -x "$NVIM_DIR/nvm.sh"
        \. "$NVM_DIR/nvm.sh"
        set --universal nvm_default_version "lts"
        set --universal nvm_default_packages tree-sitter-cli pnpm auto-changelog
        nvm use lts
      end
    end 

    if test -d "/usr/local/texlive/2024"
      set -gx MANPATH "/usr/local/texlive/2024/texmf-dist/doc/man" $MANPATH
      set -gx INFOPATH "/usr/local/texlive/2024/texmf-dist/doc/info" $INFOPATH
      set -gx PATH "/usr/local/texlive/2024/bin/x86_64-linux" $PATH
    end

    set -gx BAT_THEME "Dracula"
    set -gx XDG_CONFIG_HOME "$HOME/.config"
    set -gx XDG_CACHE_HOME "$HOME/.cache"
    set -gx COLORTERM "truecolor"
    set -gx TERM "xterm-256color"
    set -gx EDITOR "nvim"
    set -gx PAGER "less"
    set -gx BATPIPE "color"
    set -gx BATDIFF_USE_DELTA true

    if test -d "$HOME/.asdf"
      source ~/.asdf/asdf.fish
    end

    starship init fish | source

    if test -e "$HOME/.config/op/plugins.sh"
      source "$HOME/.config/op/plugins.sh"
    end

    # pnpm
    if test -d "$HOME/Library"
      if test -d "$HOME/Library/pnpm"
        set -gx PNPM_HOME "$HOME/Library/pnpm"
        if not string match -q -- $PNPM_HOME $PATH
          set -gx PATH "$PNPM_HOME" $PATH
        end
      end
    else if test -d "$HOME/.local/share/pnpm"
      set -gx PNPM_HOME "$HOME/.local/share/pnpm"
      if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
      end
    end
    # pnpm end
end

source ~/.config/fish/conda.fish
