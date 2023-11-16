#! /bin/bash

# You need to VPN into home network to use LAN broadcast address

DESKTOP_LOCAL_BROADCAST_ADDR="192.168.1.255"
DESKTOP_LOCAL_MAC_ADDR="2C:F0:5D:62:11:AF"

wakeonlan -i ${DESKTOP_LOCAL_BROADCAST_ADDR} -p 9 ${DESKTOP_LOCAL_MAC_ADDR}
