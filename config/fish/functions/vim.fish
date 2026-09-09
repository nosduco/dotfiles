function vim
    if test (count $argv) -eq 0
        echo "⚠️  Use your keybind Ctrl+E instead of typing 'vim'!"
        return 1
    else
        command vim $argv
    end
end

