#!/bin/bash

# 설정할 CAN 인터페이스와 비트레이트 정의
INTERFACE="can0"
BITRATE="1000000"

# CAN 인터페이스가 존재하는지 확인
if ! ip link show $INTERFACE &>/dev/null; then
    echo "Error: CAN 인터페이스 $INTERFACE가 존재하지 않습니다. 해당 장치가 올바르게 연결되었는지 확인하세요."
    exit 1
fi

# CAN 인터페이스가 이미 활성화되어 있는지 확인
if ip link show $INTERFACE | grep -q "state UP"; then
    echo "CAN 인터페이스 $INTERFACE는 이미 활성화되어 있습니다."
else
    # 인터페이스 비트레이트 설정
    echo "CAN 인터페이스 $INTERFACE를 비트레이트 $BITRATE로 설정 중..."
    if ! sudo ip link set $INTERFACE type can bitrate $BITRATE fd off; then
        echo "Error: CAN 인터페이스 $INTERFACE의 비트레이트 설정에 실패했습니다."
        exit 1
    fi

    # 인터페이스 활성화
    if ! sudo ip link set $INTERFACE up; then
        echo "Error: CAN 인터페이스 $INTERFACE를 활성화하는 데 실패했습니다."
        exit 1
    fi
    echo "CAN 인터페이스 $INTERFACE가 비트레이트 $BITRATE로 활성화되었습니다."
fi

# 설정이 제대로 반영되었는지 확인
echo "설정 확인 중..."
#echo ""
#ip -details link show $INTERFACE | grep "bitrate $BITRATE"
#echo ""

if ! ip -details link show $INTERFACE | grep -q "bitrate $BITRATE"; then
    echo "Error: 설정된 비트레이트 $BITRATE이 반영되지 않았습니다."
    exit 1
fi

echo "CAN 인터페이스 $INTERFACE가 비트레이트 $BITRATE로 설정되었습니다."
