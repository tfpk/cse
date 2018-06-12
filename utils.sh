lower(){
    # Convert argument to lower case
    # Args:
    #   $1: Argument in mixed case/variables
    # Echoes:
    #   $1 but in lower case only.
    echo "$1" | tr '[:upper:]' '[:lower:]'
}
