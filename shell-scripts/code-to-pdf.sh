#! /bin/bash

# $1 -- (relative) path to source file
# $2 -- (relative) path to destination file
# $3 -- [OPTIONAL] language specification for enscript

# NOTE: This uses default settings for `enscript`'s  -f [font] values

if [[ ( ${#} -lt 2 ) || ( ${#} -gt 3 ) ]]; then
    echo "Usage: code-to-pdf.sh <source file> <destination file> [OPT: language for enscript]"
    exit 1
elif [ ${#} -eq 2 ]; then
    # Use enscript's default 'guess' at language for -E[lang]
    enscript "${1}" --color=1 -C -o - | ps2pdf - "${2}"
else
    # Use ${3} for enscript's -E[lang]
    enscript ${1} --color=1 -C -E"${3}" -o - | ps2pdf - "${2}"
fi

