#!/bin/bash

##############################################################################
#
#   tmux-devour
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
        tmux split-window -h 
        c_pane=$(tmux list-panes -F "#D" | grep -v "$o_pane")
        printf '\033]2;%s\033\\' 'devour'
        tmux resize-pane -t "$c_pane" -R 20
        tmux select-pane -m -t "$c_pane"
        if [ "$HOLD_VAR" == "True" ];then
            command2=$(echo "eval \"${command}\" ; read ; tmux kill-pane -t ${c_pane}")
        else
            command2=$(echo "eval \"${command}\" ; tmux kill-pane -t ${c_pane}")
        fi
        tmux resize-pane -Z -t "$c_pane"
        tmux send-keys -t "$c_pane" "$command2" C-m
    else
        eval "$@"
    fi
