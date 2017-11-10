#! /bin/bash

# eSentire Lenovo mouse: Logitech Lenovo USB Optical Mouse
# My personal mouse: Logitech USB Laser Mouse

#MOUSE=$(xinput --list | grep -o "Logitech Lenovo USB Optical Mouse")

xinput set-prop "Logitech USB Laser Mouse" "Device Accel Profile" 0
xinput set-prop "Logitech USB Laser Mouse" "Coordinate Transformation Matrix" 0.800000, 0.000000, 0.000000, 0.000000, 0.800000, 0.000000, 0.000000, 0.000000, 1.000000
