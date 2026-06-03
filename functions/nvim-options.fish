function _test_var -a var -a val
    if test -z $val
        log error "No version set for $var in $(pwd)"
        return 1
    end
end

function nvim-options --description 'Generate the ~/.nvim/lua/options.lua file with the paths to the Python, Ruby, Node, Perl, and Go executables'
    argparse u/update -- $argv

    if set -ql _flag_u
        asdf-install python latest python
        asdf-install nodejs latest node
        asdf-install perl latest perl
        asdf-install golang latest go
    end

    set -g _python_path (asdf which python)
    _test_var Python $_python_path
    set -g _ruby_path (which ruby)
    _test_var Ruby $_ruby_path
    set -g _node_path (asdf which node)
    _test_var Node $_node_path
    set -g _perl_path (asdf which perl)
    _test_var Perl $_perl_path
    set -g _go_path (asdf which go)
    _test_var Go $_go_path
    set -g _go_exec_path (dirname $_go_path)
    set -g _go_mod_path (path normalize $_go_path/../../../bin)

    printf 'vim.g.python3_host_prog = "%s"\nvim.g.ruby_host_prog = "%s"\nvim.g.node_host_prog = "%s"\nvim.g.perl_host_prog = "%s"\nvim.env.PATH = "%s:%s:" .. vim.env.PATH\n' \
        $_python_path $_ruby_path $_node_path $_perl_path $_go_exec_path $_go_mod_path >$HOME/.config/nvim/lua/options.lua
end
