# Try to add zsh compatibility
{
    autoload bashcompinit
    bashcompinit
} || 1

DIR="$(dirname $([ -L $0 ] && readlink -f $0 || echo $0))"

source "${DIR}/autocomplete/autocomplete_local.sh"
source "${DIR}/give/give_local.sh"
