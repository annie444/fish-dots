function __notify_usage
    echo 'Usage: notify [OPTIONS] [MESSAGE]'
    echo ''
    echo 'Send a notification about the status of the last command.'
    echo ''
    echo 'If MESSAGE or --message is not provided the command will fail.'
    echo ''
    echo 'Options:'
    echo '  -m, --message MESSAGE     The message body of the notification.'
    echo '  -t, --title TITLE         The title of the notification.'
    echo '  -g, --group GROUP         The notification group identifier.'
    echo '  -e, --exit-status STATUS  The exit status of the last command.'
    echo '  -h, --help                Show this help message and exit.'
    return 0
end

function __notify_parse_args
    argparse --name notify --min-args 0 --max-args 0 --stop-nonopt \
        'm/message=' \
        't/title=' \
        'g/group=' \
        'e/exit-status=' \
        h/help -- $argv

    if set -q _flag_help
        __notify_usage
        return 1
    end

    if set -q _flag_message
        set -g __notify_message "$_flag_message"
    else if test -z "$message" -a (count $argv) -gt 0
        set -g __notify_message "$argv[1]"
    end
    if not set -q __notify_message
        echo "notify: error: the following arguments are required: MESSAGE" >&2
        __notify_usage >&2
        return 2
    end

    if set -q _flag_title
        set -g __notify_title "$_flag_title"
    else if set -q _flag_subtitle
        set -g __notify_title "$_flag_subtitle"
    else
        set -g __notify_title "Command Notification"
    end

    # If a group is provided, use it.
    # Otherwise, use the ATUIN_SESSION env var if set.
    # Otherwise, group is empty.
    if set -q _flag_group
        set -g __notify_group "$_flag_group"
    else if set -q ATUIN_SESSION
        set -g __notify_group "$ATUIN_SESSION"
    else
        set -g __notify_group fish
    end

    # If the exit status is provided and is non-zero,
    # set the urgency level to critical.
    if begin
            set -q _flag_exit_status; and test $_flag_exit_status -ne 0
        end
        set -g __notify_urgency 2
    else
        set -g __notify_urgency 1
    end
    return 0
end

function notify --description 'Send a macOS notification about the status of the last command'
    __notify_parse_args $argv
    if test $status -ne 0
        set -l return_code (math $status - 1)
        return $return_code
    end

    set -g __notify_prefix ""
    set -g __notify_suffix ""
    if set -q TMUX
        set -g __notify_prefix "\033Ptmux;\033"
        set -g __notify_suffix "\033\\"
    else if set -q STY
        set -g __notify_prefix "\033P"
        set -g __notify_suffix "\033\\"
    end

    __notify_send
    __notify_bell
    __notify_clear

    return 0
end

function __notify_send --on-event notify_send
    if begin
            set -q WEZTERM_PANE; or set -q ALACRITTY_SOCKET; or test "$TERM_PROGRAM" = ghostty
        end
        __notify_777
    else if set -q KITTY_WINDOW_ID
        __notify_99
    else
        __notify_9
    end
    if set -q ITERM_SESSION_ID
        __notify_1337
    end
    return 0
end

function __notify_9
    printf "$__notify_prefix\033]9;$__notify_title: $__notify_message\033\\$__notify_suffix"
    return 0
end

# Metadata table:
# Key | Values                       | Purpose
# ----|------------------------------|---------------------------------------
# p   | title, body, close, ?        | Payload type
# i   | alphanumeric string          | Notification identifier (for updates)
# d   | 0=more coming, 1=done        | Chunking control
# e   | 0=UTF-8, 1=base64            | Payload encoding
# u   | 0=low, 1=normal, 2=critical  | Urgency level
# o   | always, unfocused, invisible | When to display
# a   | focus, report                | Actions on click
# c   | 0, 1                         | Request close callback
function __notify_99
    set -f metadata "e=UTF-8:o=unfocused:a=focus:c=0:u=$__notify_urgency:i=$__notify_group"

    printf "$__notify_prefix\033]99;$metadata:p=title:d=0;$__notify_title\033\\$__notify_suffix"
    printf "$__notify_prefix\033]99;$metadata:p=body:d=1;$__notify_message\033\\$__notify_suffix"

    return 0
end

function __notify_777
    printf "$__notify_prefix\033]777;notify;$__notify_title;$__notify_message\033\\$__notify_suffix"
    return 0
end

# Attention request
# Value     | Effect
# ----------|--------------------------------------
# yes       | Bounce dock icon indefinitely
# once      | Bounce dock icon once
# no        | Cancel previous attention request
# fireworks | Display fireworks animation at cursor
function __notify_1337
    printf "$__notify_prefix\033]1337;RequestAttention=once\033\\$__notify_suffix"
    return 0
end

function __notify_bell
    printf "\007"
    return 0
end

function __notify_clear
    set -e __notify_prefix
    set -e __notify_suffix
    set -e __notify_message
    set -e __notify_title
    set -e __notify_group
    set -e __notify_urgency
    return 0
end
