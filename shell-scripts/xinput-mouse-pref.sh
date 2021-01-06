#! /bin/bash

# My personal mouse: Logitech USB Laser Mouse
# My personal mouse: Logitech MX Anywhere 2S

#MOUSE=$(xinput --list | grep -o "Logitech MX Anywhere 2S")

# xinput set-prop "Logitech USB Laser Mouse" "Device Accel Profile" 0

# Adjust the coordinate transformation matrix: https://askubuntu.com/a/569345
xinput set-prop "pointer:Logitech MX Anywhere 2S" "Coordinate Transformation Matrix" 0.800000, 0.000000, 0.000000, 0.000000, 0.800000, 0.000000, 0.000000, 0.000000, 1.000000
