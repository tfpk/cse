
# Try to add zsh compatibility
if [ -x "$(command -v autoload)" ]; then
    autoload bashcompinit
    bashcompinit
fi

local DIR HOST LOCAL

DIR="$(dirname $([ -L $0 ] && readlink -f $0 || echo $0))"
HOST="$(hostname --long)"
LOCAL=0

source "${DIR}/utils.sh"

if [[ "$(lower HOST)" = *"login.cse.edu.au" ]]; then
    LOCAL=1
    source "${DIR}/autocomplete/autocomplete_local.sh"
    source "${DIR}/give/give_local.sh"
else
    exit 1
fi
