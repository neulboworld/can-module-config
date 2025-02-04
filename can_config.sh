#!/bin/bash

DIR=$(dirname $0)

# CAN 인터페이스 상태 확인
INTERFACE="can0"
status=$(ip link show $INTERFACE | grep -oP "(?<=state )\w+")

echo ""
# CAN 인터페이스 상태 출력
if [ "$status" == "UP" ]; then
    echo "현재 $INTERFACE 인터페이스 상태: 활성화됨 (UP)"
    # can0가 활성화된 경우, 추가로 버스 상태 출력
    echo ""
    echo "---------------------------"
    echo ""
    echo "CAN0 버스 상태 정보: "
    ip -details link show $INTERFACE
elif [ "$status" == "DOWN" ]; then
    echo "현재 $INTERFACE 인터페이스 상태: 비활성화됨 (DOWN)"
else
    echo "현재 $INTERFACE 인터페이스 상태를 확인할 수 없습니다."
fi


# 메뉴 출력
echo ""
echo "--------------------------"
echo "CAN 인터페이스 관리"
echo "1. CAN 인터페이스 활성화"
echo "2. CAN FD 활성화"
echo "3. CAN 인터페이스 비활성화"
echo "--------------------------"
echo ""
echo -n "원하는 작업 번호를 입력하세요 (1, 2, 3): "
read choice

# 선택에 따른 작업 실행
case $choice in
    1)
        echo "CAN 인터페이스 활성화 중..."
        $DIR/_can_activation.sh
        ;;
    2)
        echo "CAN FD 활성화 중..."
        $DIR/_can_fd_activation.sh
        ;;
    3)
        echo "CAN 인터페이스 비활성화 중..."
        $DIR/_can_deactivation.sh
        ;;
    *)
        echo "잘못된 입력입니다. 1, 2, 3 중 하나를 선택하세요."
        ;;
esac

