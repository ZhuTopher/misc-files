#! /bin/bash

IP_ADDR="0.0.0.0"
PORT=8000

if [ ${#} -eq 1 ]; then
    # test if input is a number
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        if [ \( ${1} -eq 0 \) -o \( \( ${1} -ge 1024 \) -a \( ${1} -le 65535 \) \) ]; then
            # valid port value
            echo "Setting php server address to $IP_ADDR:$1"
            PORT=$1
        else
            echo "Port value was invalid."
            exit 2
        fi
    else
        echo "Input was not a number."
        exit 1
    fi
else
    echo "No port provided, defaulting to $IP_ADDR:$PORT"
fi

php -S "$IP_ADDR:$PORT"