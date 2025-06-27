function notify
    set -l title Terminal
    set -l group %self
    set -l sender "com.mitchellh.ghostty"
    set -l sound NAME
    eval "$argv"
    if test $status -ne 0
        terminal-notifier \
            -title "❌ $title 💢" \
            -subtitle "Command failed" \
            -group "$group" \
            -sender "$sender" \
            -sound "$sound" \
            --message (string join " " $argv)
        return $status
    else
        terminal-notifier \
            -title "✨ $title 💫" \
            -subtitle "Command finished successfully!" \
            -group "$group" \
            -sender "$sender" \
            -sound "$sound" \
            --message (string join " " $argv)
        return 0
    end
end
