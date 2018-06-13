# Path to local socket for SSH connection
_CSE_SESSION_SOCKET="~/.ssh/cse_socket"

# Path to the backup folder on remote:
_CSE_SESSION_BACKUP_PATH="\${HOME}/.cse_backup/"

# Path to the remote file with current directory information.
_CSE_SESSION_WD_PATH="\${HOME}/.cse_wd"

# These commands will automatically have their tildes escaped.
_CSE_AUTO_REMOTE_TILDE_COMMANDS="cd ls"
setup_cse_socket(){
    ssh -MtNf -S $_CSE_SESSION_SOCKET $_CSE
}

get_remote_wd(){
    # Connect to remote ssh server and get the "current directory" as reported by the _CSE_SESSION_WD_PATH file.
    # Args:
    #   None
    # Echoes:
    #   A remote path, or an escaped variable representing remote's home
    local remote_wd
    remote_wd="$(send_cse_command "touch "$_CSE_SESSION_WD_PATH" && cat "$_CSE_SESSION_WD_PATH"")"  
    if [[ "$remote_wd" = "" ]]; then
        # No working path found
        echo "\${HOME}"
    else
        echo "$remote_wd"
    fi
}

backup_cse_file(){
    # Backup file if it exists on remote.
    # Args:
    #   $1: The path to a file to backup on remote (including file name).
    # Echoes:
    #   None
    local backup_file_name cur_file_name cur_file_path
    
    cur_file_path="$1"
    cur_file_name="$(basename $1)"
    backup_file_name="${_CSE_SESSION_BACKUP_PATH}/$(date +%s)_${cur_file_name}"

    send_cse_command "mkdir -p ${_CSE_SESSION_BACKUP_PATH}"

    local command backup_zip
    backup_zip="${_CSE_SESSION_BACKUP_PATH}/backup.zip"
    command="test \`find ${backup_zip} -mmin +60\` && rm ${backup_zip};"
    command+="[[ -f "${cur_file_path}" || -d "${cur_file_path}" ]] && mv "${cur_file_path}" "${backup_file_name}" &&"
    command+="zip -ur ${backup_zip} ${backup_file_name} 2>&1 >> ${_CSE_SESSION_BACKUP_PATH}/compress.log && rm -r ${backup_file_name}"
    send_cse_command "$command"
}

send_cse_file(){
    # Backup file if it exists on remote, then scp the local file to replace it
    # Args:
    #   $1: The name of a file to move
    # Echoes:
    #   None
    local scp_file_name
    scp_file_name="$(get_remote_wd)/$1"
    
    backup_cse_file "${scp_file_name}"

    scp -r -o "ControlPath=${_CSE_SESSION_SOCKET}" $1 $_CSE:"${scp_file_name}"
    echo ""
}

wrap_cse_command(){
    # Print out a command that can go to an ssh shell, that moves to the current "working directory"
    # Args:
    #   $@: The command to be run on the remote machine
    # Echoes:
    #   The wrapped command
    local remote_wd command
    remote_wd="$(get_remote_wd)"
    command="cd "${remote_wd}" &&"
    command+="$@" 
    command+="&& pwd > ${_CSE_SESSION_WD_PATH};";
    printf %s "$command"
}

send_cse_command(){
    # Send a command through an established connection socket
    # Args:
    #   $@: The command to run remotely.
    # Echoes:
    #   None
    ssh -S $_CSE_SESSION_SOCKET -o LogLevel=QUIET $_CSE "$@"
}

cse(){
    # Command-line entry point. Runs special commands, constructs the remote command, 
    # calls to move files, then executes the gien command
    # Args:
    #   $@: The command to run remotely.
    #   If none, open a remote shell
    # Echoes:
    #   The result of the command
    
    # setup/close
    local arg_path
    if ! ssh -S $_CSE_SESSION_SOCKET -O check $_CSE &> /dev/null ; then
        setup_cse_socket
    elif [ "$1" = "exit" ]; then
        end_cse
        return 0
    elif [[ "$1" = "clean" ]]; then
        send_cse_command "rm -r ${_CSE_SESSION_BACKUP_PATH}"
        return 0
    fi
    
    # scp files and construct command
    local command
    command=""
    for arg in "$@"; do
        arg_path="$(echo "$arg" | tail -c +2)"

        if [[ "$arg" = "^"* ]] && [ -e "$arg_path" ]; then
            send_cse_file $arg_path
            arg="${arg_path}"
        elif [[ "$arg" = "${HOME}"* ]] && [[ "${_CSE_AUTO_REMOTE_TILDE_COMMANDS}" = *"$1"* ]]; then
            arg="~${arg#${HOME}}"
        fi
        command+=" $arg"
    done

    # send command
    if [[ "$command" = "" ]]; then
        send_cse_command ""
    else
        send_cse_command "$(wrap_cse_command "$command")"
    fi

}

end_cse(){
    # Close connection gracefully
    # Args:
    #   None
    # Echoes:
    #   None
    ssh -O exit -S $_CSE_SESSION_SOCKET $_CSE
}
