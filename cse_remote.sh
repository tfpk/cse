_CSE_SESSION_SOCKET="~/.ssh/cse_socket"
_CSE_SESSION_WD="~"

setup_cse_socket(){
    ssh -MtNf -S $_CSE_SESSION_SOCKET $CSE
}

send_cse_file(){
    scp -o "ControlPath=${_CSE_SESSION_SOCKET}" $1 $CSE:$_CSE_SESSION_WD/$1
}

send_cse_command(){
    ssh -S $_CSE_SESSION_SOCKET -o LogLevel=QUIET $CSE "$@"
}

cse(){
    local arg_path
    if ! ssh -S $_CSE_SESSION_SOCKET -O check $CSE &> /dev/null ; then
        setup_cse_socket
    elif [ "$1" = "exit" ]; then
        end_cse
        return 0
    fi
   
    local command
    command=""
    for arg in "$@"; do
        arg_path="$(echo "$arg" | tail -c +2)"
        if [[ "$arg" = "^"* ]] && [ -e "$arg_path" ]; then
            send_cse_file $arg_path
            arg="${arg_path}"
        fi
        command+=" $arg"
    done

    send_cse_command "$command"
}

end_cse(){
    ssh -O exit -S $_CSE_SESSION_SOCKET $CSE
}
