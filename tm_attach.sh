#!/bin/bash

tmux_format_str="#{session_id}: #{?session_attached,attached,not attached}"
tmux_session_name=false

while read sess; do
    echo $sess
    sess_id="$(echo $sess | sed 's/: not attached//' | sed 's/\$//')"
    tmux_session_name="$sess_id"
    break
done < <(tmux ls -F "$tmux_format_str" | grep 'not attached')

if [[ "$tmux_session_name" -ne "false" ]]; then
    tmux attach-session -t "$tmux_session_name"
else
    tmux
fi
