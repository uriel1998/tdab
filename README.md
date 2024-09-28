# tmux-devours-a-bar

Create side and top bars in tmux easily, along with a "devour" style command.

![TDAB logo](https://github.com/uriel1998/tdab/raw/master/tdab-open-graph.png "logo")

![TDAB demo](https://raw.githubusercontent.com/uriel1998/tdab/master/tdab_example.gif "demo")

You can see a larger version of the demo with the [included MKV file](https://github.com/uriel1998/tdab/blob/master/tdab_example.mkv?raw=true).

## Contents
 1. [About](#1-about)
 2. [License](#2-license)
 3. [Prerequisites](#3-prerequisites)
 4. [Installation](#4-installation)
 5. [Usage](#5-usage)
 6. [TODO](#6-todo)

***

## 1. About

These three scripts (called `TDAB` for short) will create side or top bars 
(or a "devour" style new pane) that run a command inside tmux.  See the image 
above to get an idea of what this means.  

The name is a play on "A *blank* walks into a bar", because puns.

## 2. License

This project is licensed under the MIT License. For the full license, see `LICENSE`.

## 3. Prerequisites

* tmux
* bash
* bc

These scripts will *probably* work in other shells, but I don't know for sure.

## 4. Installation

Clone or download the repository.  Put the scripts (or symlinks to the scripts) 
in your `$PATH`.  (In the example above, I've symlinked them to `sidebar`, 
`topbar`, and `devour`.)  

### Tip for `Devour`

I find a binding like the following *very* useful when using `devour`:

`bind-key -n C-/ select-pane -R \;\`
`resize-pane -Z`

This will allow you to cycle among the zoomed panes - and will zoom each as you 
go through it.  Very nice for programs like [emojin](https://github.com/peterjschroeder/emojin). 

## 5. Usage

`SCRIPTNAME [--offset NUMBER] [--hold] [program to run]`

For example, `tmux-sidebar.sh man man` will show you the man page for man in 
the sidebar.

**The optional command line arguments are POSITIONAL.** 

Resizing the bars can be done with the command line argument --offset which is 
expressed in the percentage of the screen you want for the *main* window. This 
must be the first and second argument used. For example, to have a main window 
taking up 90% of the screen, you would use

`tmux-topbar.sh --offset 90 man man`

This works by resizing the *larger* pane from the center line. 

If the *second* argument is either `-h` or `--hold` then TDAB will pause after 
executing the program and wait for you to hit a key (necessary for programs that 
exit immediately, which triggers the pane closing). 

If you run the scripts outside of tmux, it will just run the command.

### tmux_devour.sh

Launch a process in a new pane, zoom the pane, kill the pane when done.

### tmux_sidebar.sh

Create a sidebar (e.g. for reading manpages) and kill when done.

### tmux_topbar.sh

Create a vertical split and kill when done.

## 6. TODO

