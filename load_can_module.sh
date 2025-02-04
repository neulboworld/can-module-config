#!/bin/bash

CAN_LOADED=0
VCAN_LOADED=0

echo ""
echo "[CAN Modules]"
echo Loading CAN module...
sudo modprobe can

echo Loading VCAN module...
sudo modprobe vcan

if [ $? -eq 0 ]; then
    VCAN_LOADED=1
else
    echo "Loading failed. Stopped."
    exit 1
fi

if [ $? -eq 0 ]; then
    CAN_LOADED=1
else
    echo "Loading failed. Stopped."
    exit 1
fi

echo Loading ISO-TP module...
sudo modprobe can_isotp

if [ $? -eq 0 ]; then
    echo Loading PCAN-USB module...
    sudo modprobe peak_usb

    if [ $? -eq 0 ]; then
        echo Complete.
    else
        # 명령어 실패시
        echo "Failed. Loading skipped."
    fi
else
    echo "Loading failed. Stopped."
    exit 1
fi

echo ""
lsmod | grep can
echo ""

echo "[CAN Interface]"
if [ $VCAN_LOADED == 1 ]; then
    echo Adding VCAN interface...
    sudo ip link add dev vcan0 type vcan
else
    echo VCAN interface init skipped.
fi

if [ $CAN_LOADED == 1 ]; then
    echo Adding CAN interface...
    sudo ip link add dev can0 type can
else
    echo CAN interface init skipped.
fi

echo Complete.
echo ""
