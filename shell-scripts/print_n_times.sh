#! /bin/bash

# ${1} is the string to be repeated
# ${2} is the number of times to be repeated
# ${3} is a flag for whether or not to add newlines

if [ ${3} -eq 1 ]; then
	printf "${1}\n%.0s" $(seq 1 "${2}")
else
	printf "${1}%.0s" $(seq 1 "${2}")
fi

