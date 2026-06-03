function log-cmd
    set -l cmd $argv
    fish-log trace "Running command $cmd"
    eval (pipe -s -- $cmd)
    if test -n "$err"
        if test $ec -eq 0
            fish-log warn $err
        else
            fish-log error $err
        end
    end
    if test -n "$out"
        if test $ec -eq 0
            fish-log info $out
        else
            fish-log warn $out
        end
    end
end
