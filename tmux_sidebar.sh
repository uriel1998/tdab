#!/bin/bash

##############################################################################
#
#   tmux-sidebar
#   (c) Steven Saus 2020
#   Licensed under the MIT license
#
##############################################################################
# maybe use these to dynamically change width?
cols=$(tput cols)
move_width=""

    divide_and_round_up() {                                                                                                                                   
        echo "scale=2; ($1 + $2 - 1) / $2" | bc -l | awk '{printf("%d\n",$0+0.5)}'
    }  

if [ "$1" == "--fixed" ] || [ "$1" == "-f" ];then
    shift
    move_width="${1}"
    shift
fi

# if percent of offset (
offset=1.5
    if [ "$1" == "--offset" ] || [ "$1" == "-o" ];then
        shift
        offset=$(bc -l  <<<"scale=2;(2-$1/50)+1")
        shift
    fi

    HOLD_VAR=""
    if [ "$1" == "--hold" ] || [ "$1" == "-h" ];then
        HOLD_VAR="True"
        shift
    fi

    c_tmux=$(env | grep -c TMUX)
    if [ $c_tmux -gt 0 ];then
        if [ "$move_width" == "" ];then
            half_cols=$(divide_and_round_up $cols 2)
            one_third=$(divide_and_round_up $cols $offset)
            move_width=$(( one_third-half_cols ))
        fi
        command=$(echo "$@")
        o_pane=$(tmux list-panes -F "#D")
        tmux split-window -h 
        c_pane=$(tmux list-panes -F "#D" | grep -v "$o_pane")
        # Uncomment for left hand sidebar
        #tmux swap-pane -s "$o_pane" -t "$c_pane"
        printf '\033]2;%s\033\\' 'sidebar'
        tmux resize-pane -t "$c_pane" -R ${move_width}
        if [ "$HOLD_VAR" == "True" ];then
            command2=$(echo "eval \"${command}\" ; read ;tmux kill-pane -t ${c_pane}")
        else
            command2=$(echo "eval \"${command}\" ; tmux kill-pane -t ${c_pane}")
        fi
        tmux send-keys -t "$c_pane" "$command2" C-m
        tmux last-pane
    else
        eval "$@"
    fi
 
