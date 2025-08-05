function fish_user_key_bindings
    # Ctrl-E - Vim
    bind \ce --mode default open_vim
    bind \ce --mode insert open_vim

    # Ctrl-F - Files
    bind \cf --mode default fs
    bind \cf --mode insert fs

    # Shift-Tab - Complete autosuggestion
    # bind --erase --preset -k btab
    # bind -k btab accept-autosuggestion
end
