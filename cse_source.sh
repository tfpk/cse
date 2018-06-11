# Try to add zsh compatibility
{
    autoload bashcompinit 2>/dev/null
    bashcompinit 2>/dev/null
} || true

DIR=""
if [ ! -z "${BASH_SOURCE[0]}" ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
    DIR="$(dirname $([ -L $0 ] && readlink -f $0 || echo $0))"
fi
source "${DIR}/utils.sh"

HOST="$(lower `hostname --long`)"
IS_LOCAL=1

if [[ "${HOST}" = *"cse.unsw.edu.au" ]]; then
    IS_LOCAL=0
    source "${DIR}/autocomplete/autocomplete_local.sh"
    source "${DIR}/cse_local.sh"
    source "${DIR}/give/give_local.sh"
else
    source "${DIR}/cse_remote.sh"
fi
