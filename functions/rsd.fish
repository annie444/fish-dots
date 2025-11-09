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
    echo "A recursive wrapper around sd for searching and replacing text in files"
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
    echo "    <"
    set_color normal
    set_color magenta
    echo -n FIND
    set_color normal
    set_color --dim magenta
    echo ">"
    set_color normal
    echo "            The regexp or string (if using `-F`) to search for"
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
    set_color yellow
    echo -n "    -P"
    set_color normal
    echo -n ", "
    set_color yellow
    echo --file-pattern
    set_color normal
    echo "            Only process files matching the given glob pattern (e.g., `*.txt`)"
    echo ""
    set_color yellow
    echo -n "    -b"
    set_color normal
    echo -n ", "
    set_color yellow
    echo --no-backup
    echo "            Do not create backup files before making replacements (default behavior is to create"
    echo "            backups with a timestamped extension `.%Y%m%d%H%M%S.bk`)"
    echo ""
    set_color yellow
    echo -n "    -p"
    set_color normal
    echo -n ", "
    set_color yellow
    echo --preview
    echo "            Display changes in a human reviewable format (the specifics of the format are likely to"
    echo "            change in the future)"
    echo ""
    set_color yellow
    echo -n "    -F"
    set_color normal
    echo -n ", "
    set_color yellow
    echo --fixed-strings
    echo "            Treat FIND and REPLACE_WITH args as literal strings"
    echo ""
    set_color yellow
    echo -n "    -n"
    set_color normal
    echo -n ", "
    set_color yellow
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
    set_color yellow
    echo -n "    -f"
    set_color normal
    echo -n ", "
    set_color yellow
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
    echo "            Regex flags. May be combined (like `-f mc`)."
    echo ""
    echo "            c - case-sensitive"
    echo ""
    echo "            e - disable multi-line matching"
    echo ""
    echo "            i - case-insensitive"
    echo ""
    echo "            m - multi-line matching"
    echo ""
    echo "            s - make `.` match newlines"
    echo ""
    echo "            w - match full words only"
    echo ""
    set_color yellow
    echo -n "    -h"
    set_color normal
    echo -n ", "
    set_color yellow
    echo --help
    set_color normal
    echo "            Print help (see a summary with `-h`)"
    echo ""
end

function rsd --description 'Recursively search and replace text in files'

    argparse --name rsd --min-args=0 --stop-nonopt \
        h/help P/file-pattern b/no-backup p/preview \
        F/fixed-strings 'n/max-replacements=*' 'f/flags=*' \
        -- $argv

    set dir '.'
    set dir $argv[1]
    set find $argv[2]
    set replace $argv[3]

    if set -q _flag_help -o -z "$find" -o -z "$replace" -o -z "$dir"
        __rsd_help
        return 0
    end

    if test -z "$find" -o -z "$replace" -o ! -d "$dir"
        __rsd_usage
        return 1
    end

    find $dir \( -type d -name .git -prune \) -o -type f \
        -exec cp {} {}.$date.bk \; \
        -exec sd $opts "$find" "$replace" {} \;
end
