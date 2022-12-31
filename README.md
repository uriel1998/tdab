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

These scripts will *probably* work in other shells, but I don't know for sure.

## 4. Installation

Clone or download the repository.  Put the scripts (or symlinks to the scripts) 
in your `$PATH`.  (In the example above, I've symlinked them to `sidebar`, 
`topbar`, and `devour`.)  

If you wish to change the width or height of the sidebar/topbar, you will 
need to edit this line:

`tmux resize-pane -t "$c_pane" -R 30`

which actually resizes the *larger* pane from the center line. My screen that 
I used for the demo is 194 columns wide, so when it's first split, it's 97/96 
columns wide, then resizes it *to the right* an additional 30 columns so that 
I end up with a 127/67 split.  The same thing goes for the topbar, except it 
resizes upward (-U).  Adjust so that they work for your terminal size.

### Tip for `Devour`

I find a binding like the following *very* useful when using `devour`:

`bind-key -n C-/ select-pane -R \;\`
`resize-pane -Z`

This will allow you to cycle among the zoomed panes - and will zoom each as you 
go through it.  Very nice for programs like [emojin](https://github.com/peterjschroeder/emojin). 

## 5. Usage

`SCRIPTNAME [program to run]`

For example, `tmux-sidebar.sh man man` will show you the man page for man in 
the sidebar.

If the *first* argument is either `-h` or `--hold` then TDAB will pause after 
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

* Have a configurable size modifier so nobody needs to edit the script.
