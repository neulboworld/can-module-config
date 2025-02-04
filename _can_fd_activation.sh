#!/bin/bash

# 설정할 CAN 인터페이스와 비트레이트 정의
INTERFACE="can0"
NOMINAL_BITRATE="500000"   # 기본 비트레이트 (Nominal Bitrate)
DATA_BITRATE="1000000"     # 데이터 비트레이트 (Data Bitrate) for CAN FD

# CAN 인터페이스가 존재하는지 확인
if ! ip link show $INTERFACE &>/dev/null; then
    echo "Error: CAN 인터페이스 $INTERFACE가 존재하지 않습니다. 해당 장치가 올바르게 연결되었는지 확인하세요."
    exit 1
fi

# CAN 인터페이스가 이미 활성화되어 있는지 확인
if ip link show $INTERFACE | grep -q "state UP"; then
    echo "CAN 인터페이스 $INTERFACE는 이미 활성화되어 있습니다."
else
    # CAN FD 모드 활성화: 기본 비트레이트와 데이터 비트레이트 설정
    echo "CAN FD 모드를 활성화하고, 기본 비트레이트: $NOMINAL_BITRATE, 데이터 비트레이트: $DATA_BITRATE로 설정 중..."
    if ! sudo ip link set $INTERFACE type can bitrate $NOMINAL_BITRATE dbitrate $DATA_BITRATE fd on; then
        echo "Error: CAN 인터페이스 $INTERFACE의 CAN FD 비트레이트 설정에 실패했습니다."
        exit 1
    fi

    # 인터페이스 활성화
    if ! sudo ip link set $INTERFACE up; then
        echo "Error: CAN 인터페이스 $INTERFACE를 활성화하는 데 실패했습니다."
        exit 1
    fi
    echo "CAN 인터페이스 $INTERFACE가 CAN FD 모드에서 기본 비트레이트 $NOMINAL_BITRATE와 데이터 비트레이트 $DATA_BITRATE로 활성화되었습니다."
fi

# 설정이 제대로 반영되었는지 확인
echo "설정 확인 중..."
if ! ip -details link show $INTERFACE | grep -q "bitrate $NOMINAL_BITRATE"; then
    echo "Error: 설정된 기본 비트레이트 $NOMINAL_BITRATE이 반영되지 않았습니다."
    exit 1
fi
if ! ip -details link show $INTERFACE | grep -q "bitrate $DATA_BITRATE"; then
    echo "Error: 설정된 데이터 비트레이트 $DATA_BITRATE이 반영되지 않았습니다."
    exit 1
fi

echo "CAN 인터페이스 $INTERFACE가 CAN FD 모드에서 비트레이트 $NOMINAL_BITRATE와 $DATA_BITRATE로 설정되었습니다."

