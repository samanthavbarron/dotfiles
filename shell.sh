# Note: there is no shebang in this script. This script sets my preferred shell
# configuration and should be able to be sourced from any Bash-like shell or
# from Z shell.

# If we are not running interactively do not continue loading this file.
case $- in
    *i*) ;;
      *) return;;
esac

export $(cat "$HOME/dotfiles/conf.env" | xargs)

VISUAL=vim
EDITOR=vim

# Allow us to use Ctrl+S to perform forward search, by disabling the start and
# stop output control signals, which are not needed on modern systems.
stty -ixon

# Set a shell option but don't fail if it doesn't exist!
safe_set() { shopt -s "$1" >/dev/null 2>&1 || true; }

# Set some options to make working with folders a little easier. Note that we
# send all output to '/dev/null' as startup files should not write to the
# terminal and older shells might not have these options.
safe_set autocd         # Enter a folder name to 'cd' to it.
safe_set cdspell        # Fix minor spelling issues with 'cd'.
safe_set dirspell       # Fix minor spelling issues for commands.
safe_set cdable_vars    # Allow 'cd varname' to switch directory.

# Uncomment the below if you want to be able to 'cd' into directories that are
# not just relative to the current location. For example, if the below was
# uncommented we could 'cd my_project' from anywhere if 'my_project' is in
# the 'repos' folder.
# CDPATH="~:~/repos"

# Configure the history to make it large and support multi-line commands.
safe_set histappend                  # Don't overwrite the history file, append.
safe_set cmdhist                     # Multi-line commands are one entry only.
PROMPT_COMMAND='history -a'          # Before we prompt, save the history.
HISTSIZE=10000                       # A large number of commands per session.
HISTFILESIZE=100000                  # A huge number of commands in the file.
# HISTCONTROL="ignorespace:ignoredup" # Ignore starting with space or duplicates?
# export HISTIGNORE="ls:history"     # Any commands we want to not record?
HISTTIMEFORMAT='%F %T '            # Do we want a timestamp for commands?

# Colors

if [[ $(basename $SHELL) == "zsh" ]]; then
    autoload -U colors && colors
    PROMPT="%F{magenta}%n%f%F{white}@%f%F{cyan}%m%f %F{magenta}%1~%f%F{white} >%f "
elif [[ $(basename $SHELL) == "bash" ]]; then
    PS1="\[\e[35m\]\u\[\e[m\]\[\e[37m\]@\[\e[m\]\[\e[36m\]\h\[\e[m\]\[\e[35m\]\w\[\e[m\]\[\e[37m\] > \[\e[m\] "
else
    echo "Shell: $SHELL"
fi

# Aliases

alias ll="clear; pwd; ls -lh"
alias tm="~/dotfiles/tm_attach.sh"

function cs() {
    cd $1
    clear
    pwd
    echo ""
    ls
}

function hosts() {
    if [[ -f ~/.ssh/config ]]; then
        cat ~/.ssh/config | grep "Host " | sed "s/Host //"
    fi
}

if [[ $AUTO_TMUX == true ]]; then
    if [[ -z "$TMUX" ]]; then
        tm
    fi
fi

