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

    function cd -w z -d "alias cd z"
      z $argv
    end
    function .. -d "alias .. 'z ..'"
      z ..
    end
    function :q -w exit -d "alias :q exit"
      exit
    end
    function cat -w bat -d "alias cat bat"
      bat $argv
    end
    function du -w dust -d "alias du dust"
      dust $argv
    end
    function g -w git -d 'alias g git'
      git $argv
    end
    function ls -w eza -d "alias ls 'eza -1GghmMoXr --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 10'"
      eza -1GghmMoXr --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 10 $argv
    end
    function la -w eza -d "alias la 'eza -1GghmMoXrla --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 100'"
      eza -1GghmMoXrla --color=always --icons=always -s created --group-directories-first --time-style long-iso --git --git-repos --hyperlink --show-symlinks -w 100 $argv
    end
    function vim -w nvim -d "alias vim nvim"
      nvim $argv
    end
    function vi -w nvim -d "alias vi nvim"
      nvim $argv
    end
    function rm -w rmtrash -d "alias rm rmtrash"
      if test (contains "-r" $argv) -o (contains "-rf" $argv)
        rmdirtrash $argv
      else
        rmtrash $argv
      end
    end
    function rmrf -w rmdirtrash -d "alias rmrf rmdirtrash"
      rmdirtrash $argv
    end
    function rmdir -w rmdirtrash -d "alias rmdir rmdirtrash"
      rmdirtrash $argv
    end
    function tp -w trash-put -d "alias tp trash-put"
      trash-put $argv
    end
    function te -w trash-empty -d "alias te trash-empty"
      trash-empty $argv
    end
    function tl -w trash-list -d "alias tl trash-list"
      trash-list $argv
    end
    function tre -w trash-restore -d "alias tre trash-restore"
      trash-restore $argv
    end
    function trm -w trash-rm -d "alias trm trash-rm"
      trash-rm $argv
    end
    function vimdiff -w nvim -d "alias vimdiff nvim -d"
      nvim -d $argv
    end
    function diff -w batdiff -d "alias diff batdiff"
      nvim -d $argv
    end
    function find -w bfs -d "alias find bfs"
      bfs $argv
    end
    function gd -w batdiff -d "alias gd batdiff"
      batdiff $argv
    end
    function bathelp -w bat -d "alias bathelp 'bat --plain --language=help'"
      bat --plain --language=help $argv
    end
    function ssh -d "alias ssh kitten ssh"
      kitten ssh $argv
    end
    function note -w nvim -d "alias note 'nvim -c ':ObsidianToday<CR>'"
      nvim -c ':ObsidianToday<CR>' $argv
    end
    alias esp ". $HOME/esp/esp-idf/export.fish"
    

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

    if contains $HOME/.local/share/rmtrash $PATH
      set -Xg PATH $HOME/.local/share/rmtrash $PATH
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

    if test -d "$HOME/.asdf"
      source ~/.asdf/asdf.fish
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
