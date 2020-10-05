#!/bin/bash

##############################################################################
#
#   tmux-sidebar
#   (c) Steven Saus 2020
#   Licensed under the MIT license
#
##############################################################################



    c_tmux=$(env | grep -c TMUX)
    if [ $c_tmux -gt 0 ];then
        command=$(echo "$@")
        o_pane=$(tmux list-panes -F "#D")
        tmux split-window -h 
        c_pane=$(tmux list-panes -F "#D" | grep -v "$o_pane")
        # Uncomment for left hand sidebar
        #tmux swap-pane -s "$o_pane" -t "$c_pane"
        printf '\033]2;%s\033\\' 'topbar'
        tmux resize-pane -t "$c_pane" -R 30
        command2=$(echo "eval \"${command}\" ; tmux kill-pane -t ${c_pane}")
        tmux send-keys -t "$c_pane" "$command2" C-m
        tmux last-pane
    else
        eval "$@"
    fi

