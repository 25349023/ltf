#!/usr/bin/bash

__setup_ps1() {
    local GREEN='\[\033[38;5;2;1m\]'
    local BLUE='\[\033[38;5;4;1m\]'
    local PURPLE='\[\033[38;5;13m\]'
    local RED='\[\033[38;5;9m\]'
    local RESET='\[\033[m\]'

    PS1="${GREEN}\u@\h${RESET}:${BLUE}\w${PURPLE}"'$(__git_ps1 " (%s)")'"${RESET} \$ "
}

__setup_ps1

# git PS1 setup
# ============================== 
. ~/.bashrc.d/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1

