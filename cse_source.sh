# Try to add zsh compatibility
{
    autoload bashcompinit 2>/dev/null
    bashcompinit 2>/dev/null
} || true

DIR="$(dirname $([ -L $0 ] && readlink -f $0 || echo $0))"
source "${DIR}/utils.sh"

HOST="$(lower `hostname --long`)"
IS_LOCAL=0

if [[ "${HOST}" = *"cse.unsw.edu.au" ]]; then
    IS_LOCAL=1
    source "${DIR}/autocomplete/autocomplete_local.sh"
    source "${DIR}/cse_local.sh"
else
    source "${DIR}/cse_remote.sh"
fi
