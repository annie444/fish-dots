function _test_var -a var -a val
    if test -z $val
        log error "No version set for $var in $(pwd)"
        return 1
    end
end

function nvim-options
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

    begin
        echo -e "vim.g.python3_host_prog = '$_python_path'"
        echo -e "vim.g.ruby_host_prog = '$_ruby_path'"
        echo -e "vim.g.node_host_prog = '$_node_path'"
        echo -e "vim.g.perl_host_prog = '$_perl_path'"
        echo -e "vim.env.PATH = '$_go_exec_path:$_go_mod_path:' .. vim.env.PATH"
    end >$HOME/.config/nvim/lua/options.lua
end
