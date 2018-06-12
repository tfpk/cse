#!/bin/bash
_GIVE_COMPREPLY_LAST_CLASS=""
_GIVE_COMPREPLY_CLS_CONFIG=""
_GIVE_COMPREPLY_ASS_CONFIG=""
_give(){
    # Autocomplete method for give/gives
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    if [ "${COMP_CWORD}" = "1" ]; then
        if [ -z "${_GIVE_COMPREPLY_CLS_CONFIG}" ]; then
            _GIVE_COMPREPLY_CLS_CONFIG=("$(compgen -u ${cur} | grep -P "^cs\d{4}$")")
        fi
        COMPREPLY=("$(compgen -W "${_GIVE_COMPREPLY_CLS_CONFIG}") "${cur}"")
    elif [ "${COMP_CWORD}" = "2" ]; then
        if [ "${_GIVE_COMPREPLY_LAST_CLASS}" != "$prev" ] || [ -z "${_GIVE_COMPREPLY_ASS_CONFIG}" ]; then
            _GIVE_COMPREPLY_LAST_CLASS=$prev
            _GIVE_COMPREPLY_ASS_CONFIG="$(/home/${prev}/bin/classrun -assigns 2>&1 | tail -n +2)"
        fi
        COMPREPLY=($(compgen -W "$_GIVE_COMPREPLY_ASS_CONFIG" "${cur}"))
    else
        COMPREPLY=($(compgen -f "${cur}"))
    fi
}
complete -F _give give
