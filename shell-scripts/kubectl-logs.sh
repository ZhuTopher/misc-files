#! /bin/bash
# run this in your own terminal

if [ ${#} -ne 1 ]; then
	echo "Usage: . kubectl-logs.sh [POD_NAME]"
	exit 1
fi

	kubectl logs -f "${1}"
