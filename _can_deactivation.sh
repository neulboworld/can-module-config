#!/bin/bash

# 설정할 CAN 인터페이스 이름
INTERFACE="can0"

# CAN 인터페이스가 활성화되어 있는지 확인
if ip link show $INTERFACE | grep -q "state UP"; then
    # 인터페이스 비활성화
    echo "CAN 인터페이스 $INTERFACE를 비활성화 중..."
    sudo ip link set $INTERFACE down
    if [ $? -eq 0 ]; then
        echo "CAN 인터페이스 $INTERFACE가 비활성화되었습니다."
    else
        echo "Error: CAN 인터페이스 $INTERFACE를 비활성화하는 데 실패했습니다."
        exit 1
    fi
else
    echo "CAN 인터페이스 $INTERFACE는 이미 비활성화되어 있습니다."
fi

