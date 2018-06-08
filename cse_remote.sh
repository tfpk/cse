_CSE_SESSION_SOCKET="~/.ssh/cse_socket"
_CSE_SESSION_WD=""

setup_cse_socket(){
    ssh -MtNf -S $_CSE_SESSION_SOCKET $CSE
}

send_cse_command(){
    if ! ssh -S $_CSE_SESSION_SOCKET -O check $CSE &> /dev/null ; then
        setup_cse_socket
    fi
    
    ssh -S $_CSE_SESSION_SOCKET -o LogLevel=QUIET $CSE "$@"
}

cse(){
    send_cse_command "$@"
}

end_cse(){
    ssh -O exit -S $_CSE_SESSION_SOCKET $CSE
}

# Disconnect:
