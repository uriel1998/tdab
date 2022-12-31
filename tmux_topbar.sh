#!/bin/bash

##############################################################################
#
#   tmux-topbar
#   (c) Steven Saus 2020
#   Licensed under the MIT license
#
##############################################################################

    HOLD_VAR=""
    if [ "$1" == "--hold" ] || [ "$1" == "-h" ];then
        HOLD_VAR="True"
        shift
    fi


    c_tmux=$(env | grep -c TMUX)
    if [ $c_tmux -gt 0 ];then
        command=$(echo "$@")
        o_pane=$(tmux list-panes -F "#D")
        tmux split-window -v 
        c_pane=$(tmux list-panes -F "#D"| grep -v "$o_pane")
        tmux swap-pane -s "$o_pane" -t "$c_pane"
        printf '\033]2;%s\033\\' 'topbar'
        tmux resize-pane -t "$c_pane" -U 14
        if [ "$HOLD_VAR" == "True" ];then
            command2=$(echo "eval \"${command}\"  ; read; tmux kill-pane -t ${c_pane}")
        else
            command2=$(echo "eval \"${command}\"  ; read ;tmux kill-pane -t ${c_pane}")
        fi
        tmux send-keys -t "$c_pane" "$command2" C-m
        tmux last-pane
    else
        eval "$@"
    fi
