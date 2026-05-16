#!/usr/bin/env bash

dirs() {
    local N=$(builtin dirs -p | wc -l)
    if (( $# == 0 )) ; then
        if (( N > 5 )) ; then
            printf "\033[1;34mDIRSTACK:\033[0m\n"
            builtin dirs -v
        else
            printf "\033[1;34mDIRSTACK:\033[0m "
            builtin dirs
        fi
    else
        builtin dirs "$@"
    fi
}

cd() {
    local DIR
    if (( $# == 0 )) ; then
        DIR="${HOME}"
    elif [[ $1 == '-' ]] ; then
        DIR=""
    else
        DIR="$1"
    fi

    if [[ -n $DIR && $DIR != [+-]* && $(realpath -sm "$DIR") == ${PWD} ]] ; then
        return 0
    fi

    builtin pushd ${DIR:+"$DIR"} > /dev/null && dirs
}

pd() {
    local N
    if (( $# == 0 )) ; then
        N=1
    elif [[ $1 =~ ^[0-9]+$ ]] ; then
        N=$1
    else
        echo "pd: not valid argument: ${1}" >&2
        return 1
    fi

    for (( i=0; i < N; i++ )) ; do
        builtin popd &> /dev/null || break
    done

    dirs
}

alias clcd='dirs -c; dirs'
alias nx='cd +1'
alias pv='cd -0'
