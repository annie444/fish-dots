set -U fish_term24bit 1

zoxide init fish | source

direnv hook fish | source

set -U EDITOR nvim

status --is-interactive; and begin
    # Aliases
    fish_config theme choose "Dracula Official"

    set -gx GPG_TTY (tty)
    thefuck --alias | source
    set -g fish_greeting ""
    alias .. 'z ..'
    alias cd 'z'
    alias :q exit
    alias cat 'bat'
    alias du 'dust' 
    alias g 'git'
    alias gnow 'gitnow'
    alias ls 'eza --extended --bytes --links --blocksize --group --header --dereference --binary --octal-permissions --git --git-repos --long --all --all --icons --grid --classify --hyperlink --group-directories-first --time=modified --sort=extension --color=always --width=1 --time-style=long-iso'
    alias vimdiff 'nvim -d'
    alias find 'bfs'
    alias gd 'batdiff'
    alias bathelp 'bat --plain --language=help'
    alias esp ". $HOME/esp/esp-idf/export.fish"
    alias note "nvim -c ':ObsidianToday<CR>'"
    if test "$(uname)" = "Darwin"
      alias apptainer "limactl shell apptainer"
    end
    set -gx fish_greeting ""
    set -gx fzf_preview_dir eza --all --color=always
    set -gx fzf_preview_file bat
    set -gx fzf_fd_opts --hidden
    set -gx fzf_diff_highlighter delta --paging=never --width=20

    if set -q KITTY_INSTALLATION_DIR
      source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
      set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
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

    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT "-c"
    set -gx BAT_THEME "Dracula"
    set -gx XDG_CONFIG_HOME "$HOME/.config"
    set -gx XDG_CACHE_HOME "$HOME/.cache"
    set -gx COLORTERM "truecolor"
    set -gx TERM "xterm-256color"
    set -gx EDITOR "nvim"
    
    if test -d "$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t"
      set -gx SSH_AUTH_SOCK "~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else if test -d "$HOME/.1password"
      set -gx SSH_AUTH_SOCK "~/.1password/agent.sock"
    end

    if test -d /home/linuxbrew
      /home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source
    else if test -d /opt/homebrew
      /opt/homebrew/bin/brew shellenv | source
    end

    starship init fish | source
    source ~/.config/op/plugins.sh

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
