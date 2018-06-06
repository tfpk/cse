#!/bin/bash

_give(){
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    if [ "${COMP_CWORD}" = "1" ]; then
        COMPREPLY=($(compgen -W "$(ls /home | xargs)" "${cur}"))
    elif [ "${COMP_CWORD}" = "2" ]; then
        COMPREPLY=($(compgen -W "$(/home/${prev}/bin/classrun -assigns 2>&1 | tail -n +2 )" "${cur}"))
    else
        COMPREPLY=($(compgen -f "${cur}"))
    fi
}

complete -F _give give
