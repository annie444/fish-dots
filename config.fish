set -U fish_term24bit 1

zoxide init fish | source

set -U EDITOR nvim

status --is-interactive; and begin
    # Aliases
    set -gx GPG_TTY (tty)
    base16-dracula
    set -g fish_greeting ""
    thefuck --alias | source
    alias .. 'z ..'
    alias cd 'z'
    alias :q exit
    alias cat 'bat'
    alias du 'dust' 
    alias g 'git'
    alias ls 'eza --extended --bytes --links --blocksize --group --header --dereference --binary --octal-permissions --git --git-repos --long --all --all --icons --grid --classify --hyperlink --group-directories-first --time=modified --sort=extension --color=always --width=1 --time-style=long-iso'
    alias vimdiff 'nvim -d'
    alias find 'bfs'
    alias gd 'batdiff'
    alias bathelp 'bat --plain --language=help'
    base16-dracula
    set -g fish_greeting ""
    thefuck --alias | source
    if set -q KITTY_INSTALLATION_DIR
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end

    function help
      $argv --help 2>&1 | bathelp
    end

    set -gx NVM_DIR "$HOME/.nvm"

    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT "-c"
    set -gx BAT_THEME "Dracula"
    set -gx XDG_CONFIG_HOME "$HOME/.config"
    set -gx XDG_CACHE_HOME "$HOME/.cache"
    set -gx COLORTERM "truecolor"
    set -gx TERM "xterm-256color"
    
    if test -d "$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t"
      set -gx SSH_AUTH_SOCK "~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else if test -d "$HOME/.1password"
      set -gx SSH_AUTH_SOCK "~/.1password/agent.sock"
    end

    starship init fish | source
    source ~/.config/op/plugins.sh

    set -gx BUPSTASH_REPOSITORY /mnt/backups/bupstash
end

source ~/.config/fish/conda.fish
