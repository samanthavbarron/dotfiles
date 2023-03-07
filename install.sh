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

# Source shell.sh to config file

ln -sf "$HOME/dotfiles/shell.sh" "$HOME/.shell.sh"
RC_PATH="$HOME/.$(basename $CURRENT_SHELL)rc"
touch $RC_PATH
# Check if this line exists on $RC_PATH, if not append it
src_cmd="[ -r ~/.shell.sh ] && source ~/.shell.sh"
if [[ $(cat $RC_PATH | grep -w "$src_cmd") ]]; then
    echo ""
else
    echo ""
    echo $src_cmd >> $RC_PATH
fi
