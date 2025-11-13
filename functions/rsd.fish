function __rsd_usage
    set_color --bold green
    echo -n "Usage: "
    set_color normal
    set_color --bold cyan
    echo -n "rsd "
    set_color normal
    set_color --dim yellow
    echo -n "["
    set_color normal
    set_color yellow
    echo -n OPTIONS
    set_color normal
    set_color --dim yellow
    echo -n "] "
    set_color normal
    set_color --dim magenta
    echo -n "<"
    set_color normal
    set_color magenta
    echo -n DIRECTORY
    set_color normal
    set_color --dim magenta
    echo -n "> <"
    set_color normal
    set_color magenta
    echo -n FIND
    set_color normal
    set_color --dim magenta
    echo -n "> <"
    set_color normal
    set_color magenta
    echo -n REPLACE_WITH
    set_color normal
    set_color --dim magenta
    echo ">"
    set_color normal
end

function __rsd_help
    echo "rsd v1.0.0"
    echo ""
    set_color --bold
    echo "A recursive wrapper around sd for searching and replacing text in files"
    set_color normal
    echo ""
    set_color --bold green
    __rsd_usage
    set_color --bold green
    echo ""
    echo "Arguments:"
    set_color normal
    set_color --dim magenta
    echo -n "    <"
    set_color normal
    set_color magenta
    echo -n DIRECTORY
    set_color normal
    set_color --dim magenta
    echo ">"
    set_color normal
    echo "            The path to the directory to search recursively"
    echo "            "
    echo "            Defaults to the current directory if not specified."
    echo ""
    set_color --dim magenta
    echo -n "    <"
    set_color normal
    set_color magenta
    echo -n FIND
    set_color normal
    set_color --dim magenta
    echo ">"
    set_color normal
    echo -n "            The regexp or string (if using `"
    set_color yellow
    echo -n -F
    set_color normal
    echo "`) to search for"
    echo ""
    set_color --dim magenta
    echo -n "    <"
    set_color normal
    set_color magenta
    echo -n REPLACE_WITH
    set_color normal
    set_color --dim magenta
    echo ">"
    set_color normal
    echo "            What to replace each match with. Unless in string mode, you may use captured values like"
    echo "            \$1, \$2, etc"
    echo ""
    set_color --bold green
    echo "Options:"
    set_color normal
    set_color cyan
    echo -n "    -P"
    set_color normal
    echo -n ", "
    set_color cyan
    echo --file-pattern
    set_color normal
    echo -n "            Only process files matching the given glob pattern (e.g., `"
    set_color yellow
    echo -n "*.txt"
    set_color normal
    echo "`)"
    echo ""
    set_color cyan
    echo -n "    -b"
    set_color normal
    echo -n ", "
    set_color cyan
    echo --no-backup
    set_color normal
    echo "            Do not create backup files before making replacements (default behavior is to create"
    echo -n "            backups with a timestamped extension `"
    set_color yellow
    echo -n ".%Y%m%d%H%M%S.bk"
    set_color normal
    echo "`)"
    echo ""
    set_color cyan
    echo -n "    -p"
    set_color normal
    echo -n ", "
    set_color cyan
    echo --preview
    set_color normal
    echo "            Display changes in a human reviewable format (the specifics of the format are likely to"
    echo "            change in the future)"
    echo ""
    set_color cyan
    echo -n "    -F"
    set_color normal
    echo -n ", "
    set_color cyan
    echo --fixed-strings
    set_color normal
    echo "            Treat FIND and REPLACE_WITH args as literal strings"
    echo ""
    set_color cyan
    echo -n "    -n"
    set_color normal
    echo -n ", "
    set_color cyan
    echo -n --max-replacements
    set_color normal
    set_color --dim blue
    echo -n " <"
    set_color normal
    set_color blue
    echo -n LIMIT
    set_color normal
    set_color --dim blue
    echo ">"
    set_color normal
    echo "            Limit the number of replacements that can occur per file. 0 indicates unlimited"
    echo "            replacements"
    echo ""
    set_color --dim red
    echo "            [default: 0]"
    set_color normal
    echo ""
    set_color cyan
    echo -n "    -f"
    set_color normal
    echo -n ", "
    set_color cyan
    echo -n "--flags "
    set_color normal
    set_color --dim blue
    echo -n "<"
    set_color normal
    set_color blue
    echo -n FLAGS
    set_color normal
    set_color --dim blue
    echo ">"
    set_color normal
    echo -n "            Regex flags. May be combined (like `"
    set_color yellow
    echo -n "-f mc"
    set_color normal
    echo "`)."
    echo ""
    echo "            c - case-sensitive"
    echo ""
    echo "            e - disable multi-line matching"
    echo ""
    echo "            i - case-insensitive"
    echo ""
    echo "            m - multi-line matching"
    echo ""
    echo -n "            s - make `"
    set_color yellow
    echo -n "."
    set_color normal
    echo "` match newlines"
    echo ""
    echo "            w - match full words only"
    echo ""
    set_color cyan
    echo -n "    -h"
    set_color normal
    echo -n ", "
    set_color cyan
    echo --help
    set_color normal
    echo -n "            Print help (see a summary with `"
    set_color yellow
    echo -n -h
    set_color normal
    echo "`)"
    echo ""
end

function rsd --description 'Recursively search and replace text in files'

    argparse --name rsd --min-args=0 --stop-nonopt \
        h/help P/file-pattern b/no-backup p/preview \
        F/fixed-strings 'n/max-replacements=*' 'f/flags=*' \
        -- $argv

    set dir './'
    if test (count $argv) -ge 1
        set -f dir $argv[1]
        set -f find $argv[2]
        set -f replace $argv[3]
    end
    set -f date (date +%Y%m%d%H%M%S)

    if set -ql _flag_help
        __rsd_help
        return 0
    end
    if test -z "$find" -o -z "$replace" -o ! -d "$dir"
        __rsd_usage
        return 1
    end

    set -f findopts -type f
    set -f sdopts

    if set -ql _flag_file_pattern
        set -a findopts -o
        set -a findopts -name
        set -a findopts $_flag_file_pattern
    end

    if not set -ql _flag_no_backup
        set -a findopts -exec cp "{}" "{}.$date.bk" ";"
    end

    if set -ql _flag_preview
        set -a sdopts --preview
    end

    if set -ql _flag_fixed_strings
        set -a sdopts -F
    end

    if set -ql _flag_max_replacements
        set -a sdopts -n $_flag_max_replacements
    end

    if set -ql _flag_flags
        set -a sdopts -f $_flag_flags
    end

    echo "Running: find $dir ( -type d -name .git -prune ) -o $findopts -exec sd $sdopts \"$find\" \"$replace\" {} ;"

    find $dir \( \( -type d -name .git \) -o \( -type f -name "*.bk" \) -prune \) -o $findopts \
        -exec sd $sdopts "$find" "$replace" {} \;
end
