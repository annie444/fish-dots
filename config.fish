set -U fish_term24bit 1

zoxide init fish | source

set -U EDITOR nvim

status --is-interactive; and begin
    # Aliases
    alias .. 'cd ..'
    alias :q exit
    alias cat 'bat'
    alias du 'dust' 
    alias g 'git'
    alias la 'll -a'
    alias ll 'ls -l --time-style long-iso --icons'
    alias ls 'eza --extended --bytes --links --blocksize --group --header --dereference --binary --octal-permissions --git --git-repos --long --all --all --icons --grid --classify --hyperlink --group-directories-first --time=modified --sort=extension --color=always --width=1 --time-style=long-iso'
    alias vimdiff 'nvim -d'
    alias find 'bfs'
    alias fd 'bfs'
    alias gd 'batdiff'
    alias bathelp 'bat --plain --language=help'
    base16-dracula
    set -g fish_greeting ""
    thefuck --alias | source
    if set -q KITTY_INSTALLATION_DIR
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end

    set -gx NVM_DIR "$HOME/.nvm"

    set -g MANPAGER "sh -c 'col -bx | bat -l man -p'"
    
    set -g USE_GKE_GCLOUD_AUTH_PLUGIN true
    
    set -g BAT_THEME dracula
    set -g TERM "xterm-256color"
    
    set -g JAVA_HOME "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
    set -g ANDROID_HOME "$HOME/Library/Android/sdk"
    set -g NDK_HOME "$ANDROID_HOME/ndk/25.0.8775105"

    set -g SSH_AUTH_SOCK "~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"

    starship init fish | source
    source ~/.config/op/plugins.sh
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f $HOME/miniforge3/bin/conda
    eval $HOME/miniforge3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

