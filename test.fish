#!/usr/bin/env fish

function _echo_help
    set msg $argv[-1]
    argparse b/background o/bold d/dim i/italics u/underline r/reverse n/newline c/color= -- $argv[1..-2]
    if test -n "$_flag_b" -o -n "$_flag_o" -o -n "$_flag_d" -o -n "$_flag_i" -o -n "$_flag_u" -o -n "$_flag_r" -o -n "$_flag_c"
        set_color $_flag_b $_flag_o $_flag_d $_flag_i $_flag_u $_flag_r $_flag_c
    end
    echo $_flag_n $msg >&2
    set_color normal
end

function _update_usage
    _echo_help -n -o -c BD93F9 "Usage: "
    _echo_help -n -c 8BE9FD "update "
    _echo_help -n -c FFB86C "[-h|--help] "
    _echo_help -c 50FA7B "<target>"
    _echo_help ""
    _echo_help "Update various tools and configurations."
    _echo_help ""
    _echo_help -o -c BD93F9 "Flags:"
    _echo_help -n -c F1FA8C "    -h"
    _echo_help -n ", "
    _echo_help -n -c F1FA8C "--help    "
    _echo_help -d "Show this help message and exit"
    _echo_help ""
    _echo_help -o -c BD93F9 "Supported targets:"
    _echo_help -n -c 50FA7B "    chezmoi   "
    _echo_help -n -i -d "(alias: "
    _echo_help -n -i -c 50FA7B chez
    _echo_help -i -d ")"
    _echo_help -c 50FA7B "    asdf"
    _echo_help -n -c 50FA7B "    neovim    "
    _echo_help -n -i -d "(alias: "
    _echo_help -n -i -c 50FA7B nvim
    _echo_help -i -d ")"
    _echo_help -n -c 50FA7B "    fishshell "
    _echo_help -n -i -d "(alias: "
    _echo_help -n -i -c 50FA7B fish
    _echo_help -i -d ")"
    _echo_help -n -c 50FA7B "    wezterm   "
    _echo_help -n -i -d "(alias: "
    _echo_help -n -i -c 50FA7B wez
    _echo_help -i -d ")"
    _echo_help -n -c 50FA7B "    homebrew  "
    _echo_help -n -i -d "(alias: "
    _echo_help -n -i -c 50FA7B brew
    _echo_help -n -i -d ")  "
    _echo_help -i -d "[macOS only]"
    _echo_help -c 50FA7B "    all"
    _echo_help ""
    _echo_help -n -o -c BD93F9 "NOTE: "
    _echo_help "The neovim, fish, and wezterm targets will commit and push all changes"
    _echo_help "from the local dotfiles in the `~/.dotfiles' directory then update the chezmoi repo."
end

_update_usage
