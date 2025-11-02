#!/bin/bash

##############################################################################
#
#   tmux-topbar
#   (c) Steven Saus 2025
#   Licensed under the MIT license
#  --fixed [offset] | --offset [percent] --hold --bottom
##############################################################################
lines=$(tput lines)

    divide_and_round_up() {                                                                                                                                   
        echo "scale=2; ($1 + $2 - 1) / $2" | bc -l | awk '{printf("%d\n",$0+0.5)}'
    }  
  
if [ "$1" == "--fixed" ] || [ "$1" == "-f" ];then
    shift
    move_height="${1}"
    echo "fixed offset of $move_height"
    shift
    offset=""
else
    # if percent of offset (
    offset=1.4
    if [ "$1" == "--offset" ] || [ "$1" == "-o" ];then
        shift
        offset=$(bc -l  <<<"scale=2;(2-$1/$lines)+1")
        shift
        half_lines=$(divide_and_round_up $lines 2)
        one_fifth=$(divide_and_round_up $lines $offset)
        move_height=$(( one_fifth-half_lines))    
    fi
fi


    HOLD_VAR=""
    if [ "$1" == "--hold" ] || [ "$1" == "-h" ];then
        HOLD_VAR="True"
        shift
    fi

    BOTTOM_VAR=""
    if [ "$1" == "--bottom" ] || [ "$1" == "-b" ];then
        BOTTOM_VAR="True"
        if [ "$offset" == "" ];then
            half_lines=$(divide_and_round_up $lines 2)
            if [ -n "$move_height" ];then
                move_height=$(( half_lines - move_height ))
            fi
            shift
        fi
    else
        if [ "$offset" == "" ];then
            half_lines=$(divide_and_round_up $lines 2)
            move_height=$(( half_lines - move_height ))
        fi       
    fi

    c_tmux=$(env | grep -c TMUX)
    if [ $c_tmux -gt 0 ];then
        command=$(echo "$@")
        o_pane=$(tmux list-panes -F "#D")
        tmux split-window -v 
        c_pane=$(tmux list-panes -F "#D"| grep -v "$o_pane")
        if [ "${BOTTOM_VAR}" != "True" ];then
            tmux swap-pane -s "$o_pane" -t "$c_pane"
            if [ $move_height -lt 0 ];then
                move_height=$(echo "$move_height" | awk '{ if($1>=0) {print $1} else {print $1*-1}}')
                tmux resize-pane -t "$c_pane" -D $move_height
            else
                tmux resize-pane -t "$c_pane" -U $move_height
            fi
        else
            if [ $move_height -lt 0 ];then
                move_height=$(echo "$move_height" | awk '{ if($1>=0) {print $1} else {print $1*-1}}')
                tmux resize-pane -t "$o_pane" -D $move_height
            else
                tmux resize-pane -t "$d_pane" -D $move_height
            fi
        fi
        printf '\033]2;%s\033\\' 'topbar'
        if [ "$HOLD_VAR" == "True" ];then
            command2=$(echo "eval \"${command}\"  ; read ; tmux kill-pane -t ${c_pane}")
        else
            command2=$(echo "eval \"${command}\"  ; tmux kill-pane -t ${c_pane}")
        fi
        tmux send-keys -t "$c_pane" "$command2" C-m
        tmux last-pane
    else
        eval "$@"
    fi
