#! /bin/bash

if [[ -z ${@} ]]; then
    echo "USAGE: <command> <args>..."
    exit 1
fi

echo "Executing from ${PWD}"
echo "Command being executed: ${@}"

# https://stackoverflow.com/a/1885670 
read -p "Please confirm: (y/N) " choice
case "${choice}" in
    y|Y ) ;;
    * ) exit 0;;
esac

# 1. git status --short
# 2. Use `sed` to remove the `git st` XY-prefixes
#    - M: modified
#    - A: added
#    - D: deleted
#    - R: renamed
#    - ?: untracked
files="$(git st -s | sed -rn 's/[?MADR]+[[:space:]]+([^[:space:]]+)/\1/p')"
for file in ${files}; do
    echo "${@} ${file}"
    ${@} "${file}"
done

exit 0
