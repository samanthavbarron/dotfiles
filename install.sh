#!/bin/bash

# Import variables
export $(cat conf.env | xargs)

# Determine and set preferred shell
CURRENT_SHELL=$(basename $SHELL)
if [[ $(basename $SHELL) != $SHELL_PREF ]]; then
    if [[ $(command -v $SHELL_PREF) ]]; then
        chsh -s $(which $SHELL_PREF)
        CURRENT_SHELL=$SHELL_PREF
    else
        echo "Could not find $SHELL_PREF"
    fi
else
    echo "Shell is already $SHELL_PREF"
fi

RC_PATH="$HOME/.$(basename $CURRENT_SHELL)rc"
touch $RC_PATH

# Source $file to config file
config_files=( shell.sh local.sh )
for file in "${config_files[@]}"; do
    echo "Sourcing $file"
    ln -sf "$HOME/dotfiles/$file" "$HOME/.$file"
    # Check if this line exists on $RC_PATH, if not append it
    src_cmd="[ -r ~/.$file ] && source ~/.$file"
    if [[ $(cat $RC_PATH | grep -w "$src_cmd") ]]; then
        echo ""
    else
        echo ""
        echo $src_cmd >> $RC_PATH
    fi
done


if [[ $CONTROLLER ]]; then
    echo "Controller"
else
    echo "Not controller"
fi
