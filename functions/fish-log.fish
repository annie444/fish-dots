function fish-log -a log_level
    set -f log_date (date "+%FT%T%z")

    if test $log_level = trace
        set_color blue
    else if test $log_level = info
        set_color green
    else if test $log_level = warn
        set_color yellow
    else if test $log_level = error
        set_color red
    end

    if test $log_level = error
        echo -e "timestamp="$log_date "level="$log_level 'msg="'$argv[2..-1]'"' >&2
    else if test $log_level = warn
        echo -e "timestamp="$log_date "level="$log_level 'msg="'$argv[2..-1]'"' >&2
    else
        echo -e "timestamp="$log_date "level="$log_level 'msg="'$argv[2..-1]'"'
    end

    set_color normal
end
