function rsd \
    --description 'Recursively search and replace text in files' \
    --argument-names dir find replace

    set opts $argv[4..-1]
    set -l date (date +%Y%m%d%H%M%S)

    if test -z "$find" -o -z "$replace" -o -d "$dir"
        echo "Usage: rsd <directory> <text_to_find> <replacement_text> <sd_options>"
        return 1
    end

    find $dir \( -type d -name .git -prune \) -o -type f --exec --exec cp {} {}.$date.bk \; --exec sd $opts "$find" "$replace" {} \;
end
