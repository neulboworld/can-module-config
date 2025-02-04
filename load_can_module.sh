#!/bin/bash

echo ""
echo Loading CAN module...
sudo modprobe can
echo Loading ISO-TP module...
sudo modprobe can_isotp
echo Loading PCAN-USB module...
sudo modprobe peak_usb
echo Complete.
echo ""
lsmod | grep can
echo ""
