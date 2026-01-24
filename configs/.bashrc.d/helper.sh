#!/usr/bin/bash

ff() {
    # ff stands for Fast Find (grep in current directory recursively)
    local pattern=$1
    if [[ -n $pattern ]] ; then
        grep -nirE --color=always -e "$pattern" . | tee /tmp/${USER}-last-ff | less -R
    else
        # retrieve last ff result
        less -R /tmp/${USER}-last-ff
    fi
}
