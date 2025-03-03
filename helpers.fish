function add_path
    set -l path $argv
    if not contains $path $PATH
        set -gx --prepend PATH $path
    end
end

function test_add_path
    set -l path $argv
    if test -d $path
        add_path $path
    end
end

function add_complete
    set -l path $argv
    if not contains $path $fish_complete_path
        set -gx --prepend fish_complete_path $path
    end
end

function test_add_complete
    set -l path $argv
    if test -d $path
        add_complete $path
    end
end

function add_functions
    set -l path $argv
    if not contains $path $fish_function_path
        set -gx --prepend fish_function_path $path
    end
end

function test_add_functions
    set -l path $argv
    if test -d $path
        add_complete $path
    end
end
