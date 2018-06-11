gives(){
    echo "WARNING: by running this program you are agreeing to the terms of the "give" program."
    echo "You should review them and consent to them before using this program!"
    echo "yes\nyes\n" | give "$@"
}
complete -F _give gives
